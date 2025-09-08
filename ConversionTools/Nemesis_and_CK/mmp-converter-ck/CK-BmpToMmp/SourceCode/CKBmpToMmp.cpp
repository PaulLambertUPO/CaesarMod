//£ukasz Rychter 2009

#ifndef _WIN32_WINNT           
	#define _WIN32_WINNT 0x0501	
#endif

#define WIN32_LEAN_AND_MEAN   //don't compile unnecessary headers
#define VC_EXTRALEAN
#define NOSERVICE
#define NOMCX
#define NOIME

#include <windows.h>

#include <shlobj.h>

#include <conio.h>
#include <tchar.h>
#include <iostream>

using namespace std;


///////////////////////////////////////////////////////////////////////////////////////////


struct NEMESIS_RLE_HEADER
{
	char IMGRLE[6];    //"IMGRLE"
	BYTE type;		   //image type??? 0x01, 0x02, 0x06 means 8bpp, 0x04 means shadow (8bpp but only 2 colors), 0x00, 0x05 means 15bpp(5-5-5), .... ????
	BYTE x00_1[11];    //always (?) 11 x 0x00 bytes
	WORD directions;   //number of image frames stripped horizontally (directions)
	BYTE x00_2[2];	   //always (?) 3 x 0x00 bytes
	WORD animFrames;   //number of image frames stripped vertically (animation)
	BYTE x00_3[2];	   //always (?) 2 x 0x00 bytes
}; 
//26 bytes total


struct NEMESIS_RLE_FRAME_HEADER
{
	WORD leftBGmargin;		 //width of the background strip on the left, before graphics
	BYTE x00_1[2];		 	 //always (?) 2 x 0x00 bytes
	WORD topBGmargin;		 //height of the background strip on the top, before graphics
	BYTE x00_2[2];			 //always (?) 2 x 0x00 bytes
	WORD width;				 //width of the frame INCLUDING background strips, -1 pixel
	BYTE x00_3[2];			 //always (?) 2 x 0x00 bytes
	WORD height;			 //height of the frame INCLUDING background strips, -1 pixel
	BYTE x00_4[2];			 //always (?) 2 x 0x00 bytes
	char RLE2[4];			 //"RLE2"
	WORD FrameWidth;		 //width of the single frame (excluding background stips)
	BYTE x00_5[2];			 //always (?) 2 x 0x00 bytes
	WORD FrameHeight;		 //height of the single frame (excluding background stips)
	BYTE x00_6[2];			 //always (?) 2 x 0x00 bytes
	BYTE type;				 //some kind of type??? Usually 0x01, rarely 0x03 ...
	WORD FrameSize[2];		 //frame size, in bytes, including indexes
	BYTE x00_7[8];			 //always (?) 8 x 0x00 bytes
	WORD BGcolor;			 //background color, 15bpp(5-5-5) or index in palette
	BYTE x00_8[2];			 //always (?) 2 x 0x00 bytes
}; 
//46 bytes total



///////////////////////////////////////////////////////////////////////////////////////////
TCHAR szInputPath[MAX_PATH] = {0};
TCHAR szOutputPath[MAX_PATH] = {0};

WORD AllFilesCount = 0;
WORD ConvertedCount = 0;
///////////////////////////////////////////////////////////////////////////////////////////





#define GetError() _GetError(__LINE__, __FILE__)

void _GetError(long line, char* file)
{
	DWORD err = GetLastError();

	TCHAR MsgBuf[512];
	FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM, NULL, err, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), MsgBuf, 256, NULL );

	wprintf_s( L"Error in %S line %d: %s\n\n", file, line, &MsgBuf );
}




///////////////////////////////////////////////////////////////////////////////////////////




void ConvertBmpToRle( TCHAR* szBmpPath, TCHAR* szRlePath )
{
	HANDLE hFile = INVALID_HANDLE_VALUE;
	HANDLE hRleFile = INVALID_HANDLE_VALUE;
	HANDLE hRleFileBig = INVALID_HANDLE_VALUE;
	BYTE* ImageData = NULL;
	BYTE* RleImageData = NULL;
	WORD* LinesOffsets = NULL;

	struct _RGBA
	{
		BYTE r,g,b,a;
	};
	_RGBA* Palette = NULL;

	NEMESIS_RLE_HEADER hdr = {0};

	BITMAPINFOHEADER bih = {0};
	BITMAPFILEHEADER bfh = {0};

	///////////////////////////

	++AllFilesCount;
	wprintf_s( L"\nConverting \"%s\"\nto         \"%s\"\n", szBmpPath, szRlePath );


	hFile = CreateFile( szBmpPath, FILE_READ_DATA, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_FLAG_SEQUENTIAL_SCAN, NULL );
	if ( hFile == INVALID_HANDLE_VALUE )
	{
		cout << "ERROR: "; GetError(); cout << "\n";
		goto clean;
	}

	//read BMP header
	DWORD br = 0;
	int r = ReadFile( hFile, &bfh, sizeof(bfh), &br, NULL );
	if ( !r || br < sizeof(bfh) )
	{
		cout << "ERROR: "; GetError(); cout << "\n";
		goto clean;
	} 

	r = ReadFile( hFile, &bih, sizeof(bih), &br, NULL );
	if ( !r || br < sizeof(bih) )
	{
		cout << "ERROR: "; GetError(); cout << "\n";
		goto clean;
	} 


	//checking if file is correct Windows BMP ("BM" and right header size)
	if ( bfh.bfType != 0x4d42 || bih.biSize != sizeof(bih) )
	{
		cout << "ERROR: This is not correct Windows type BMP file!\n\n";
		goto clean;
	}

	//checking if it is 8 or 16bit. Only those this program can take.
	if ( bih.biBitCount != 8 && bih.biBitCount != 16 )
	{
		cout << "ERROR: This is " << bih.biBitCount << "bpp bitmap. This program can read out only 8 and 16bpp files.\n\n";
		goto clean;
	}

	//checking if this BMP is uncompressed. Reading off compressed bitmaps is not implemented.
	if ( bih.biCompression != BI_RGB )
	{
		cout << "ERROR: BMP cannot be compessed!\n\n";
		goto clean;
	}

	hdr.IMGRLE[0] = 'I'; hdr.IMGRLE[1] = 'M'; hdr.IMGRLE[2] = 'G'; hdr.IMGRLE[3] = 'R'; hdr.IMGRLE[4] = 'L'; hdr.IMGRLE[5] = 'E';

	DWORD PaletteColors=0;
	BYTE BPP;
	if ( bih.biBitCount == 8 )
	{
		BPP = 1; //file contain pallete

		PaletteColors = (DWORD)bih.biClrUsed;
		if ( PaletteColors == 0 && bih.biBitCount == 8 ) PaletteColors = 256;

		Palette = new _RGBA[PaletteColors];

		r = ReadFile( hFile, Palette, PaletteColors * sizeof(_RGBA), &br, NULL ); //read palette from BMP file
		if ( !r || br < PaletteColors * sizeof(_RGBA) )
		{
			cout << "ERROR: "; GetError(); cout << "\n";
			goto clean;
		} 
	}
	else BPP = 2;

	if ( BPP == 2 ) hdr.type = 0x00; //16bpp
	else if (PaletteColors==2) hdr.type=0x04; //shadow
	else hdr.type = 0x02; //normal 8bpp
	


	int val = 0;

	cout << "\nAnimation frames: ";
	
	while ( wcin >> val, val <= 0 || val > 255 )
	{
		cout << "Invalid value. Type number in range 1-255.\nAnimation frames: ";

		wcin.clear();
		wcin.putback( 0 );
		wcin.ignore( 999, 0 );
		wcin.sync();
	}
	hdr.animFrames = val;

	if ((bih.biHeight-hdr.animFrames+1)%hdr.animFrames != 0)
	{
		cout << "Invalid frames number (image can not be divided to eqal frames)\n\n";
		goto clean;
	}


	cout << "Directions: ";
	
	while ( wcin >> val, val <= 0 || val > 255 )
	{
		cout << "Invalid value. Type number in range 1-255.\nDirections: ";

		wcin.clear();
		wcin.putback( 0 );
		wcin.ignore( 999, 0 );
		wcin.sync();
	}
	hdr.directions = val;

	if ((bih.biWidth-hdr.directions+1)%hdr.directions != 0)
	{
		cout << "Invalid directions number (image can not be divided to eqal frames)\n\n";
		goto clean;
	}


	hRleFile = CreateFile( szRlePath, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL );
	if ( hRleFile == INVALID_HANDLE_VALUE )
	{
		cout << "ERROR: "; GetError(); cout << "\n";
		goto clean;
	}

	hRleFileBig = CreateFile( L"rle.mmp", GENERIC_WRITE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL );
	if ( hRleFileBig == INVALID_HANDLE_VALUE )
	{
		cout << "ERROR: "; GetError(); cout << "\n";
		goto clean;
	}


	DWORD bw = 0;
	r = WriteFile( hRleFile, &hdr, sizeof(hdr), &bw, NULL ); //RLE header
	if ( !r || bw < sizeof(hdr) )
	{
		cout << "ERROR: "; GetError(); cout << "\n";
		goto clean;
	}


	
	WORD ImgDataW;
	if (BPP == 1) ImgDataW = ((WORD)bih.biWidth + 3)/4 * 4; //8bit BMP line data must be DWORD(4byte) aligned
	else ImgDataW = ((WORD)bih.biWidth + 1)/2 * 2;	//15bit BMP line data must be WORD(2byte) aligned

	ImageData = new BYTE[ImgDataW * bih.biHeight * BPP]; 

	if ( SetFilePointer( hFile, bfh.bfOffBits, NULL, FILE_BEGIN ) == INVALID_SET_FILE_POINTER )
	{
		cout << "ERROR: "; GetError(); cout << "\n";
		goto clean;
	} 


	r = ReadFile( hFile, ImageData, ImgDataW * bih.biHeight * BPP, &br, NULL ); //read bmp image
	if ( !r || br < (DWORD)(ImgDataW * bih.biHeight * BPP) )
	{
		cout << "ERROR: "; GetError(); cout << "\n";
		goto clean;
	} 


	for ( WORD frame = 0; frame<hdr.animFrames; ++frame )
	{
		for ( WORD dir = 0; dir<hdr.directions; ++dir )
		{
			DWORD FileOffset; 
 			if ( (FileOffset = SetFilePointer( hRleFileBig, 0, NULL, FILE_END )) == INVALID_SET_FILE_POINTER )
			{
				cout << "ERROR: "; GetError(); cout << "\n";
				goto clean;
			} 

			NEMESIS_RLE_FRAME_HEADER fhdr = {0};

			fhdr.RLE2[0] = 'R'; fhdr.RLE2[1] = 'L'; fhdr.RLE2[2] = 'E'; fhdr.RLE2[3] = '2'; 
			fhdr.type = 0x01;

			fhdr.width = ((WORD)bih.biWidth-hdr.directions+1)/hdr.directions;
			fhdr.height = ((WORD)bih.biHeight-hdr.animFrames+1)/hdr.animFrames;

			RleImageData = new BYTE[fhdr.width * fhdr.height * BPP * 2]; //Don't know yet Rle image size so make enough room for sure
			LinesOffsets = new WORD[fhdr.height];
			WORD LinesOffsetsSize = fhdr.height * sizeof(WORD);

			if (BPP == 1) 
				if ( hdr.type == 0x04 ) fhdr.BGcolor = 0;
				else fhdr.BGcolor = 64;
			else fhdr.BGcolor = 0x3E0; //green background

			

			WORD pos = 0;
			fhdr.leftBGmargin = 0;
			fhdr.topBGmargin = 0;
			for ( int y = bih.biHeight-frame*fhdr.height-1 - frame; y >= bih.biHeight-(frame+1)*fhdr.height - frame; --y )
			{
				LinesOffsets[fhdr.height-(y-(hdr.animFrames-frame-1)*fhdr.height - (hdr.animFrames-frame-1))-1] = LinesOffsetsSize + pos;

				WORD x = dir*fhdr.width + dir;
				do
				{
					BYTE bgcount = 0;
					while ( ImageData[(y * ImgDataW + x)*BPP] == (fhdr.BGcolor&0xff) && ((BPP == 2) ? (ImageData[(y * ImgDataW + x)*BPP + 1] == ((fhdr.BGcolor&0xff00) >> 8)) : 1)  )
					{
						++bgcount;
						++x;
						if ( x == (dir+1)*fhdr.width + dir || bgcount == 255 ) break;
					}
					RleImageData[pos] = bgcount;

					++pos;


					BYTE abcount = 0;
					if ( x < (dir+1)*fhdr.width + dir )
					{
						while ( !(ImageData[(y * ImgDataW + x)*BPP] == (fhdr.BGcolor&0xff) && ((BPP == 2) ? (ImageData[(y * ImgDataW + x)*BPP + 1] == ((fhdr.BGcolor&0xff00) >> 8)) : 1)) )
						{
							++abcount;
							++x;
							if ( x == (dir+1)*fhdr.width + dir || abcount == 255 ) break;
						}
						RleImageData[pos] = abcount;
						++pos;
							
						if ( hdr.type != 0x04 )
						{
							memcpy( &(RleImageData[pos]), &(ImageData[(y * ImgDataW + (x-abcount))*BPP]), abcount*BPP );
							pos += abcount*BPP;
						}
					}
					else
					{
						RleImageData[pos] = 0;
						++pos;
					}
				} while (x < (dir+1)*fhdr.width + dir);
			}

			fhdr.FrameWidth = fhdr.width;
			fhdr.FrameHeight = fhdr.height;
			--fhdr.width;
			--fhdr.height;

			fhdr.FrameSize[0] = (WORD)((pos+LinesOffsetsSize) & 0xFFFF);
			fhdr.FrameSize[1] = (WORD)(((pos+LinesOffsetsSize) & 0xFFFF0000) >> 16);

			r = WriteFile( hRleFile, &fhdr, sizeof(fhdr), &bw, NULL ); //frame header
			if ( !r || bw < sizeof(fhdr) )
			{
				cout << "ERROR: "; GetError(); cout << "\n";
				goto clean;
			}

			r = WriteFile( hRleFile, "pamm", 4, &bw, NULL ); //frame header
			if ( !r || bw < 4 )
			{
				cout << "ERROR: "; GetError(); cout << "\n";
				goto clean;
			}
			r = WriteFile( hRleFile, &FileOffset, 4, &bw, NULL ); //frame header
			if ( !r || bw < 4 )
			{
				cout << "ERROR: "; GetError(); cout << "\n";
				goto clean;
			}

			r = WriteFile( hRleFileBig, LinesOffsets, LinesOffsetsSize, &bw, NULL ); //offsets table
			if ( !r || bw < LinesOffsetsSize )
			{
				cout << "ERROR: "; GetError(); cout << "\n";
				goto clean;
			}


			r = WriteFile( hRleFileBig, RleImageData, pos, &bw, NULL );
			if ( !r || bw < pos )
			{
				cout << "ERROR: "; GetError(); cout << "\n";
				goto clean;
			}

			delete[] LinesOffsets;
			LinesOffsets = NULL;
			delete[] RleImageData;
			RleImageData = NULL;
		}
	}


	if (hdr.type == 0x04) PaletteColors = 0;
	r = WriteFile( hRleFile, &PaletteColors, 4, &bw, NULL );
	if ( !r || bw < 4 )
	{
		cout << "ERROR: "; GetError(); cout << "\n";
		goto clean;
	}

	if (BPP == 1 && hdr.type != 0x04) //Add palette
	{
		r = WriteFile( hRleFile, Palette, PaletteColors * sizeof(_RGBA), &bw, NULL );
		if ( !r || bw < PaletteColors * sizeof(_RGBA) )
		{
			cout << "ERROR: "; GetError(); cout << "\n";
			goto clean;
		}	

		WORD Palette16[256];
		for ( WORD i=0; i<PaletteColors; ++i ) Palette16[i] = ((WORD)(Palette[i].b&0xF8) << 7) | ((WORD)(Palette[i].g&0xF8) << 2) | ((WORD)(Palette[i].r&0xF8) >> 3);
		
		r = WriteFile( hRleFile, Palette16, PaletteColors * sizeof(WORD), &bw, NULL );
		if ( !r || bw < PaletteColors * sizeof(WORD) )
		{
			cout << "ERROR: "; GetError(); cout << "\n";
			goto clean;
		}
	}


	cout << "\nFile successfully converted.\n";
	++ConvertedCount;

clean:
	CloseHandle( hRleFile );
	CloseHandle( hRleFileBig );
	delete[] Palette;
	delete[] LinesOffsets;
	delete[] RleImageData;
	delete[] ImageData;
	CloseHandle( hFile );
}



///////////////////////////////////////////////////////////////////////////////////////////



void FindRleFiles( TCHAR* SubPath )
{
	WIN32_FIND_DATA fd;
	TCHAR szFPath[MAX_PATH] = {0};
	TCHAR szFPath2[MAX_PATH] = {0};
	TCHAR szFPath3[MAX_PATH] = {0};

	swprintf_s( szFPath, sizeof(szFPath)/2, L"%s\\%s\\*", szInputPath, SubPath );

	HANDLE ff = FindFirstFile( szFPath, &fd );
	if ( ff == INVALID_HANDLE_VALUE ) 
	{
		GetError();
		return;
	}
	while (1)
	{
		if ( fd.cFileName[0] != '.' ) 
		{
			if ( fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY ) //found directory
			{
				if (SubPath[0]) 	 //recurenntly search files in folders and subfolders...
				{
					swprintf_s( szFPath, sizeof(szFPath)/2, L"%s\\%s", SubPath, fd.cFileName );
					FindRleFiles( szFPath );
				}
				else FindRleFiles( fd.cFileName );
			
			}
			else
			{
				WORD len = (WORD)wcslen(fd.cFileName);
				if ( fd.cFileName[len-4] == L'.' && (fd.cFileName[len-3] == L'b' || fd.cFileName[len-3] == L'B') && (fd.cFileName[len-2] == L'm' || fd.cFileName[len-2] == L'M') && (fd.cFileName[len-1] == L'p' || fd.cFileName[len-1] == L'P') )
				{
					
					if (SubPath[0])
					{
						swprintf_s( szFPath, sizeof(szFPath)/sizeof(TCHAR), L"%s\\%s\\%s", szInputPath, SubPath, fd.cFileName );
						swprintf_s( szFPath2, sizeof(szFPath2)/sizeof(TCHAR), L"%s\\%s\\%s", szOutputPath, SubPath, fd.cFileName );
					} 
					else
					{
						swprintf_s( szFPath, sizeof(szFPath)/sizeof(TCHAR), L"%s\\%s", szInputPath, fd.cFileName );
						swprintf_s( szFPath2, sizeof(szFPath2)/sizeof(TCHAR), L"%s\\%s", szOutputPath, fd.cFileName );
					}
					swprintf_s( szFPath3, sizeof(szFPath3)/sizeof(TCHAR), L"%s\\%s", szOutputPath, SubPath );
					
					wcout << L"File '" << szFPath << L"' found.\nDo you wish to convert it? Y/N: ";
					wchar_t c;
					while ( wcin >> c, !(c == L'y' || c == L'Y' || c == 'n' || c == 'N') )
					{
						cout << "Invalid selection. Type Y for Yes or N for No: ";

						wcin.clear();
						wcin.putback( 0 );
						wcin.ignore( 999, 0 );
						wcin.sync();
					}

					if ( c == L'y' || c ==L'Y' )
					{
						len = (WORD)wcslen(szFPath2);
						szFPath2[len-3] = L'M'; szFPath2[len-2] = L'M'; szFPath2[len-1] = L'P';

						int r = SHCreateDirectoryEx(0, szFPath3, NULL);
						if ( r != ERROR_SUCCESS && r != ERROR_FILE_EXISTS && r != ERROR_ALREADY_EXISTS  )
						{
							if ( r == ERROR_BAD_PATHNAME )
							{
								TCHAR szCurrDir[MAX_PATH] = {0};
								GetCurrentDirectory( sizeof(szCurrDir)/sizeof(TCHAR), szCurrDir );
								swprintf_s( szFPath3, sizeof(szFPath3)/sizeof(TCHAR), L"%s\\%s\\%s", szCurrDir, szOutputPath, SubPath );
								r = SHCreateDirectoryEx(0, szFPath3, NULL);
								if ( r != ERROR_SUCCESS && r != ERROR_FILE_EXISTS && r != ERROR_ALREADY_EXISTS ) GetError();
							}
							else GetError();
						}

						ConvertBmpToRle( szFPath, szFPath2 );
					}
					else cout << "File skipped.\n";
				}
			}
		}
		if ( !FindNextFile( ff, &fd ) )
		{
			if ( GetLastError() == ERROR_NO_MORE_FILES ) break;
			else GetError();
		}
	}
	if ( !FindClose( ff ) ) GetError();
}




///////////////////////////////////////////////////////////////////////////////////////////
	



void CleanPath( TCHAR* path )
{
	if ( path[0] )
	{
		while (1) //removing \, /, \n, \r and " from path end
		{
			WORD len = (WORD)wcslen(path);
			if ( (path[len-1] == '\\') || (path[len-1] == '//') || (path[len-1] == '\n') || (path[len-1] == '\r') || (path[len-1] == '"') ) path[len-1] = 0;
			else break;
		}
	}
}




///////////////////////////////////////////////////////////////////////////////////////////
	



int _tmain(int argc, TCHAR* argv[])
{
	cout << "NemesisBmpToRle Converter\n\n";

	if ( argc >= 2 ) wcscpy_s( szInputPath, sizeof(szInputPath)/2, argv[1] );
	if ( argc >= 3 ) wcscpy_s( szOutputPath, sizeof(szOutputPath)/2, argv[2] );

	///////////////////////

	WORD len;
	if ( !szInputPath[0] ) 
	{
		cout << "Please specify (absolute or relative) path to look for BMP files.\nPick up just one file (eg C:\\Image.bmp) or choose folder (eg C:\\Images).\nAll *.bmp files found inside chosen folder and its subfolders will be converted.\n";
		cout << "Source path: ";

		DWORD chr;
		if ( !ReadConsole( GetStdHandle(STD_INPUT_HANDLE), szInputPath, sizeof(szInputPath), &chr, NULL ) ) GetError();
	}
	CleanPath( szInputPath );

	DWORD InputType;
	while ( InputType = GetFileAttributes( szInputPath ), InputType == INVALID_FILE_ATTRIBUTES )
	{
		cout << "\nInvalid source path! Try again: ";

		DWORD chr;
		if ( !ReadConsole( GetStdHandle(STD_INPUT_HANDLE), szInputPath, sizeof(szInputPath), &chr, NULL ) ) GetError();
		szInputPath[chr] = 0;
		CleanPath( szInputPath );
	}

	///////////////////////
	
	if ( !szOutputPath[0] ) 
	{
		cout << "\nPlease specify (absolute or relative) path where to save RLE file(s).\n* If you have picked up just one file you can choose exact output file name\n  (eg C:\\MyImage.rle) or just folder (eg C:\\MyImages, file name will be then\n  the same as input, just replacing extension with *.rle).\n* Otherwise *.bmp files will be written with original names but *.rle extension,  saving original directory structure, relative to the source path.\n\n";
		cout << "Destination path: ";
		
		DWORD chr;
		if ( !ReadConsole( GetStdHandle(STD_INPUT_HANDLE), szOutputPath, sizeof(szOutputPath), &chr, NULL ) ) GetError();
	}
	CleanPath( szOutputPath );

	DWORD OutputType;
	HANDLE hTmp = INVALID_HANDLE_VALUE;
	while ( hTmp = CreateFile( szOutputPath, FILE_READ_ATTRIBUTES, FILE_SHARE_READ, NULL, OPEN_ALWAYS, FILE_FLAG_DELETE_ON_CLOSE, NULL ), OutputType = GetFileAttributes(szOutputPath), !((OutputType == FILE_ATTRIBUTE_DIRECTORY) || ((hTmp != INVALID_HANDLE_VALUE) && (!(InputType & FILE_ATTRIBUTE_DIRECTORY)))) )
	{
		CloseHandle( hTmp );
		cout << "\nInvalid output path! Try again: ";

		DWORD chr;
		if ( !ReadConsole( GetStdHandle(STD_INPUT_HANDLE), szOutputPath, sizeof(szOutputPath), &chr, NULL ) ) GetError();
		szOutputPath[chr] = 0;
		CleanPath( szOutputPath );
	}
	CloseHandle( hTmp );
	cout << "\n";
	

	///////////////////////

	
	if ( InputType & FILE_ATTRIBUTE_DIRECTORY ) FindRleFiles( L"" );
	else 
	{
		if ( OutputType & FILE_ATTRIBUTE_DIRECTORY ) // automatically take the name of the source file, but change the extension to BMP
		{
			len = (WORD)wcslen(szInputPath);
			int c;
			for ( c = len-1; c >= 0; --c )
			{
				if ( (szInputPath[c] == '\\') || (szInputPath[c] == '/') ) break;
			}

			WORD len2 = (WORD)wcslen(szOutputPath);
			szOutputPath[len2] = '\\'; ++len2;
			for ( int c2 = c + 1; c2 < len; ++c2 )
			{
				if ( szInputPath[c2] == '.' ) break;
				szOutputPath[len2] = szInputPath[c2];
				++len2;
			}
			szOutputPath[len2] = '.'; szOutputPath[len2+1] = 'R'; szOutputPath[len2+2] = 'L'; szOutputPath[len2+3] = 'E'; szOutputPath[len2+4] = 0; 
		}
		ConvertBmpToRle( szInputPath, szOutputPath );
	}


	///////////////////////


	//Summay info
	if ( AllFilesCount == ConvertedCount && ConvertedCount > 0 ) 
	{
		if ( ConvertedCount == 1 ) cout << "\n1 file was converted successfully.\n\n";
		else cout << "\nAll (" << ConvertedCount << ") files were converted successfully.\n\n";
	}
	else 
	{
		if ( ConvertedCount == 0 ) cout << "\nNo files were converted!\n\n";
		else cout << "\n" << ConvertedCount << " out of " << AllFilesCount << " files were converted successfully.\n\n";
	}

	cout << "Press any key to exit ";

	_getch();


	return 0;
}

