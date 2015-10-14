#include <windows.h>
#include <tchar.h>

extern int _tmain(int argc, TCHAR *argv[]);

#ifdef UNICODE
int main() {
	int     argc = 0;
	LPWSTR* argv = CommandLineToArgvW(GetCommandLineW(), &argc);
	return _tmain(argc, argv);
}
#endif
