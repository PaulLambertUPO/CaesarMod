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
	BYTE x00_2[2];	   //always (?) 2 x 0x00 bytes
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




void ConvertRleToBmp( TCHAR* szRlePath, TCHAR* szBmpPath )
{
	HANDLE hFile = INVALID_HANDLE_VALUE;
	HANDLE hMmpFile = INVALID_HANDLE_VALUE;
	HANDLE hBmpFile = INVALID_HANDLE_VALUE;
	BYTE* ImageData = NULL;
	WORD* LinesOffsets = NULL;

	BYTE** FramesData = NULL;

	NEMESIS_RLE_HEADER hdr = {0};
	NEMESIS_RLE_FRAME_HEADER* fhdr = NULL;

	BITMAPINFOHEADER bih = {0};
	BITMAPFILEHEADER bfh = {0};
	
	struct _RGBA
	{
		BYTE r,g,b,a;
	};
	_RGBA* Palette = NULL;


	///////////////////////////

	++AllFilesCount;
	wprintf_s( L"Converting \"%s\"\nto         \"%s\" ... ", szRlePath, szBmpPath );


	hFile = CreateFile( szRlePath, FILE_READ_DATA, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_FLAG_SEQUENTIAL_SCAN, NULL );
	if ( hFile == INVALID_HANDLE_VALUE )
	{
		cout << "FAILED!\n"; GetError(); cout << "\n";
		goto clean;
	}

	hMmpFile = CreateFile( L"rle.mmp", FILE_READ_DATA, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_FLAG_SEQUENTIAL_SCAN, NULL );
	if ( hMmpFile == INVALID_HANDLE_VALUE )
	{
		cout << "FAILED!\n"; GetError(); cout << "\n";
		goto clean;
	}

	//read RLE header
	DWORD br = 0;
	int r = ReadFile( hFile, &hdr, sizeof(hdr), &br, NULL );
	if ( !r || br < sizeof(hdr) )
	{
		cout << "FAILED!\n"; GetError(); cout << "\n";
		goto clean;
	} 


	//checking if file is correct Nemezis's RLE. BMP format with RLE compression has sometimes *.rle extension too, so this is important. There is also Utah RLE format... 
	if ( !(hdr.IMGRLE[0] == 'I' && hdr.IMGRLE[1] == 'M' && hdr.IMGRLE[2] == 'G' && hdr.IMGRLE[3] == 'R' && hdr.IMGRLE[4] == 'L' && hdr.IMGRLE[5] == 'E')  )
	{
		cout << "FAILED!\nThis is not correct Nemesis's MMP file\n\n";
		goto clean;
	}


	BYTE BPP;
	if ( hdr.type == 0x01 || hdr.type == 0x02 ||  hdr.type == 0x04/*shadow*/ || hdr.type == 0x06 ) BPP = 1; //8BPP
	else BPP = 2;


	FramesData = new BYTE*[hdr.animFrames*hdr.directions];
	fhdr =  new NEMESIS_RLE_FRAME_HEADER[hdr.animFrames*hdr.directions];

	WORD ImgDataW=0;

	WORD maxFrameW=0;
	WORD maxFrameH=0;
	for ( WORD frame=0; frame<hdr.animFrames*hdr.directions; ++frame )
	{
		//read RLE frame header
		int r = ReadFile( hFile, &fhdr[frame], sizeof(fhdr[frame]), &br, NULL );
		if ( !r || br < sizeof(fhdr[frame]) )
		{
			cout << "FAILED!\n"; GetError(); cout << "\n";
			goto clean;
		} 

		struct
		{
			char pamm[4];	//"pamm"
			WORD offset[2];	//image data offser in rle.mmp file
		} offhdr;

		//read additional offset header
		r = ReadFile( hFile, &offhdr, sizeof(offhdr), &br, NULL );
		if ( !r || br < sizeof(offhdr) )
		{
			cout << "FAILED!\n"; GetError(); cout << "\n";
			goto clean;
		} 


	
		if (maxFrameW < fhdr[frame].width+1) maxFrameW = fhdr[frame].width+1;
		if (maxFrameH < fhdr[frame].height+1) maxFrameH = fhdr[frame].height+1;

		FramesData[frame] = new BYTE[(fhdr[frame].height+1)*(fhdr[frame].width+1)*BPP];	

		for (WORD iy=0; iy<fhdr[frame].height+1; ++iy)
		{
			for (WORD ix=0; ix<fhdr[frame].width+1; ++ix)
			{
				if (BPP==1) FramesData[frame][iy*(fhdr[frame].width+1) + ix] = hdr.type==0x04?0:64;
				else
				{
					FramesData[frame][(iy*(fhdr[frame].width+1) + ix)*BPP] = (BYTE)(fhdr[frame].BGcolor & 0xFF);
					if (BPP == 2) FramesData[frame][(iy*(fhdr[frame].width+1) + ix)*BPP + 1] = (BYTE)(fhdr[frame].BGcolor >> 8);
				}
			}
		}


	
		if ( SetFilePointer( hMmpFile, offhdr.offset[0] | (offhdr.offset[1] << 16), NULL, FILE_BEGIN ) == INVALID_SET_FILE_POINTER )
		{
			cout << "ERROR: "; GetError(); cout << "\n";
			goto clean;
		} 


		LinesOffsets = new WORD[fhdr[frame].FrameHeight+1];

		r = ReadFile( hMmpFile, LinesOffsets, fhdr[frame].FrameHeight * sizeof(WORD), &br, NULL ); //read table of offsets to each image line. LinesOffsets[X] + HeaderSize(26bytes) + FrameHeaderSize(46bytes) = position in file where line data starts
		if ( !r || br < fhdr[frame].FrameHeight * sizeof(WORD) )
		{
			cout << "FAILED!\n"; GetError(); cout << "\n";
			goto clean;
		} 

		LinesOffsets[fhdr[frame].FrameHeight] = fhdr[frame].FrameSize[0] | (fhdr[frame].FrameSize[1] << 16); 

		for ( int y = 0; y < fhdr[frame].FrameHeight; ++y )
		{
			WORD LineSize = (WORD)(LinesOffsets[y+1] - LinesOffsets[y]);
			BYTE* LineBuf = new BYTE[LineSize];

			r = ReadFile( hMmpFile, LineBuf, LineSize, &br, NULL ); //read line data
			if ( !r || br < LineSize )
			{
				cout << "FAILED!\n"; GetError(); cout << "\n";
				delete[] LineBuf;
				goto clean;
			}

			WORD pos = 0;
			WORD x = fhdr[frame].leftBGmargin;
			
			bool bg = true;
			do
			{
				if (bg)
				{
					x += LineBuf[pos]; 
					++pos;
					bg = false;
				}
				else
				{
					WORD pixels = LineBuf[pos];
					++pos;
					for ( int i = 0; i < pixels; ++i )
					{
						if ( BPP==2 ) //normal or stripped image, 15bit color
						{
							FramesData[frame][((y + fhdr[frame].topBGmargin) * (fhdr[frame].width+1) + x)*2] = LineBuf[pos];
							FramesData[frame][((y + fhdr[frame].topBGmargin) * (fhdr[frame].width+1) + x)*2+1] = LineBuf[pos+1];
							pos += 2;
						}
						else //256 color image with color table
						{
							if (hdr.type == 0x04) FramesData[frame][(y + fhdr[frame].topBGmargin) * (fhdr[frame].width+1) + x] = 1; //shadow
							else
							{
								if (LineBuf[pos] == 64) LineBuf[pos] = 0;
								FramesData[frame][(y + fhdr[frame].topBGmargin) * (fhdr[frame].width+1) + x] = LineBuf[pos];
								++pos;
							}
						}

						++x;
					}
					bg = true;
				}
			} while (pos < LineSize);

			delete[] LineBuf;
		}
	}


	if (BPP == 1) ImgDataW = (maxFrameW*hdr.directions + (hdr.directions-1) + 3)/4 * 4; //8bit BMP line data must be DWORD(4byte) aligned
	else ImgDataW = (maxFrameW*hdr.directions + (hdr.directions-1) + 1)/2 * 2;	//15bit BMP line data must be WORD(2byte) aligned

	WORD ImgH = maxFrameH * hdr.animFrames + (hdr.animFrames-1);
	WORD ImgW = maxFrameW * hdr.directions + (hdr.directions-1);

	ImageData = new BYTE[ImgDataW * ImgH * BPP]; 
			
	for (WORD iy=0; iy<ImgH; ++iy)
	{
		for (WORD ix=0; ix<ImgW; ++ix)
		{
			if (BPP == 1)
			{
				if ((ix>0 && ix%maxFrameW==ix/maxFrameW-1) || (iy>0 && iy%maxFrameH==iy/maxFrameH-1)) ImageData[(iy*ImgDataW + ix)*BPP] = hdr.type==0x04?1:65;
				else ImageData[(iy*ImgDataW + ix)*BPP] = hdr.type==0x04?0:64;
			}
			else
			{
				if ((ix>0 && ix%maxFrameW==0) || (iy>0 && iy%maxFrameH)) 
				{
					ImageData[(iy*ImgDataW + ix)*BPP] = 0;
					ImageData[(iy*ImgDataW + ix)*BPP+1] = 0;
				}
				else
				{
					ImageData[(iy*ImgDataW + ix)*BPP] = (BYTE)(fhdr[0].BGcolor & 0xFF);
					ImageData[(iy*ImgDataW + ix)*BPP + 1] = (BYTE)(fhdr[0].BGcolor >> 8);
				}
			}
		}
	}
		
	

	for ( WORD dir=0; dir<hdr.directions; ++dir )
	{
		for ( WORD frame=0; frame<hdr.animFrames; ++frame )
		{

			for (WORD iy=0; iy<fhdr[frame*hdr.directions + dir].height+1; ++iy)
				memcpy(ImageData + (hdr.animFrames-frame-1)*maxFrameH*ImgDataW*BPP + (maxFrameH-iy-1)*ImgDataW*BPP + (hdr.animFrames-frame-1)*ImgDataW*BPP + dir*maxFrameW*BPP + dir*BPP, FramesData[frame*hdr.directions + dir] + iy*(fhdr[frame*hdr.directions + dir].width+1)*BPP, (fhdr[frame*hdr.directions + dir].width+1)*BPP );
		}
	}



	struct PALETTE_HEADER
	{
		WORD PaletteColors;
		BYTE x00[2];
	} phdr;

	//read palette header
	r = ReadFile( hFile, &phdr, sizeof(phdr), &br, NULL );
	if ( !r || br < sizeof(phdr) )
	{
		cout << "FAILED!\n"; GetError(); cout << "\n";
		goto clean;
	} 


	if (BPP==1)
	{
		Palette = new _RGBA[phdr.PaletteColors];

		if ( hdr.type == 0x01 || hdr.type == 0x02 )
		{
			r = ReadFile( hFile, Palette, phdr.PaletteColors * sizeof(_RGBA), &br, NULL ); //read palette from RLE file
			if ( !r || br < phdr.PaletteColors * sizeof(_RGBA) )
			{
				cout << "FAILED!\n"; GetError(); cout << "\n";
				goto clean;
			} 

			if ( hdr.type == 0x02 )
			{
				for ( int c=0; c<64; ++c )
				{	
					Palette[c].r = c*4;
					Palette[c].g = c*4;
					Palette[c].b = c*4;
					Palette[c].a = 0;
				}
			}
		}
		else if ( hdr.type == 0x04 ) //shadow
		{
			Palette = new _RGBA[2];

			Palette[0].r = 0; Palette[0].g = 255; Palette[0].b = 0; Palette[0].a = 0;
			Palette[1].r = Palette[1].g = Palette[1].b = Palette[1].a = 0;

			phdr.PaletteColors = 2;
		}
		else
		{
			Palette = new _RGBA[256];

			for ( int c=0; c<256; ++c )
			{	
				Palette[c].r = c;
				Palette[c].g = c;
				Palette[c].b = c;
				Palette[c].a = 0;
			}
			phdr.PaletteColors = 256;
		}
	}


	bih.biSize = sizeof(bih); 
	bih.biWidth = ImgW; 
	bih.biHeight = ImgH; 
	bih.biPlanes = 1; 
	bih.biBitCount = BPP*8; 
	bih.biCompression = BI_RGB; 
	bih.biSizeImage = ImgDataW * bih.biHeight * BPP; 
	bih.biXPelsPerMeter = 0; 
	bih.biYPelsPerMeter = 0; 
	bih.biClrUsed = phdr.PaletteColors; 
	bih.biClrImportant = phdr.PaletteColors; 

	bfh.bfType = 0x4d42;        // 0x42 = "B" 0x4d = "M" 
	bfh.bfOffBits = sizeof(bfh) + bih.biSize + phdr.PaletteColors * sizeof(_RGBA);
	bfh.bfSize = bfh.bfOffBits + bih.biSizeImage;
	
	hBmpFile = CreateFile( szBmpPath, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL );
	if ( hBmpFile == INVALID_HANDLE_VALUE )
	{
		cout << "FAILED!\n"; GetError(); cout << "\n";
		goto clean;
	}

	DWORD bw = 0;
	r = WriteFile( hBmpFile, &bfh, sizeof(bfh), &bw, NULL );
	if ( !r || bw < sizeof(bfh) )
	{
		cout << "FAILED!\n"; GetError(); cout << "\n";
		goto clean;
	}

	r = WriteFile( hBmpFile, &bih, sizeof(bih), &bw, NULL );
	if ( !r || bw < sizeof(bih) )
	{
		cout << "FAILED!\n"; GetError(); cout << "\n";
		goto clean;
	}

	if (BPP == 1) //Add palette
	{
		if (hdr.type != 0x04 )
		{
			_RGBA tmpC = Palette[fhdr[0].BGcolor];
			Palette[fhdr[0].BGcolor] = Palette[64];
			Palette[64] = tmpC;
		}

		r = WriteFile( hBmpFile, Palette, phdr.PaletteColors * sizeof(_RGBA), &bw, NULL );
		if ( !r || bw < phdr.PaletteColors * sizeof(_RGBA) )
		{
			cout << "FAILED!\n"; GetError(); cout << "\n";
			goto clean;
		}	
	}


	r = WriteFile( hBmpFile, ImageData, ImgDataW * ImgH * BPP, &bw, NULL );
	if ( !r || bw < (DWORD)(ImgDataW * ImgH * BPP) )
	{
		cout << "FAILED!\n"; GetError(); cout << "\n";
		goto clean;
	}
	

	cout << "OK\n\n";
	++ConvertedCount;

clean:
	CloseHandle( hBmpFile );
	delete[] Palette;
	delete[] LinesOffsets;
	delete[] ImageData;
	if (FramesData) for (int i=0; i<hdr.animFrames*hdr.directions; ++i) delete[] FramesData[i];
	delete[] FramesData;
	delete[] fhdr;
	CloseHandle( hMmpFile );
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
				if ( fd.cFileName[len-4] == L'.' && (fd.cFileName[len-3] == L'm' || fd.cFileName[len-3] == L'M') && (fd.cFileName[len-2] == L'm' || fd.cFileName[len-2] == L'M') && (fd.cFileName[len-1] == L'p' || fd.cFileName[len-1] == L'P') )
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
					
					len = (WORD)wcslen(szFPath2);
					szFPath2[len-3] = L'B'; szFPath2[len-2] = L'M'; szFPath2[len-1] = L'P';

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

					ConvertRleToBmp( szFPath, szFPath2 );
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
	cout << "NemesisMMPtoBMP Converter\n\n";

	if ( argc >= 2 ) wcscpy_s( szInputPath, sizeof(szInputPath)/2, argv[1] );
	if ( argc >= 3 ) wcscpy_s( szOutputPath, sizeof(szOutputPath)/2, argv[2] );

	///////////////////////

	WORD len;
	if ( !szInputPath[0] ) 
	{
		cout << "Please specify (absolute or relative) path to look for MMP files.\nPick up just one file (eg C:\\Image.mmp) or choose folder (eg C:\\Images).\nAll *.mmp files found inside chosen folder and its subfolders will be converted.\n";
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
		CleanPath( szInputPath );
	}

	///////////////////////
	
	if ( !szOutputPath[0] ) 
	{
		cout << "\nPlease specify (absolute or relative) path where to save BMP file(s).\n* If you have picked up just one file you can choose exact output file name\n  (eg C:\\MyImage.bmp) or just folder (eg C:\\MyImages, file name will be then\n  the same as input, just replacing extension with *.bmp).\n* Otherwise *.rle files will be written with original names but *.bmp extension,  saving original directory structure, relative to the source path.\n\n";
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
		CleanPath( szOutputPath );
	}
	CloseHandle( hTmp );
	

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
			szOutputPath[len2] = '.'; szOutputPath[len2+1] = 'B'; szOutputPath[len2+2] = 'M'; szOutputPath[len2+3] = 'P'; 
		}
		ConvertRleToBmp( szInputPath, szOutputPath );
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

