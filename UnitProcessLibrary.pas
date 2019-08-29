unit UnitProcessLibrary;

// @author: https://codeoncode.blogspot.com/2016/12/get-processid-by-programname-include.html

interface

uses
  System.SysUtils,
  Winapi.Messages,
  Winapi.PsAPI,
  Winapi.TlHelp32,
  Winapi.Windows;

const
  NO_PATH = '';

function GetPathFromPID(const PID: cardinal): string;

  // Get ProcessID By ProgramName (Include Path or Not Include)
function GetPIDByProgramName(const APName: string): THandle;

// Get Window Handle By ProgramName (Include Path or Not Include)
function GetHWndByProgramName(const APName: string): THandle;

// Get Window Handle By ProcessID
function GetHWndByPID(const hPID: THandle): THandle;

// Get ProcessID By Window Handle
function GetPIDByHWnd(const hWnd: THandle): THandle;

// Get Process Handle By Window Handle
function GetProcessHndByHWnd(const hWnd: THandle): THandle;

// Get Process Handle By Process ID
function GetProcessHndByPID(const hAPID: THandle): THandle;


implementation

function GetPathFromPID(const PID: cardinal): string;
var
  hProcess: THandle;
  path: array[0..MAX_PATH - 1] of char;
begin
  hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, false, PID);
  if hProcess <> 0 then
    try
      if GetModuleFileNameEx(hProcess, 0, path, MAX_PATH) = 0 then
        Exit;

      Result := path;
    finally
      CloseHandle(hProcess)
    end;
end;

// Get Window Handle By ProgramName (Include Path or Not Include)
function GetHWndByProgramName(const APName: string): THandle;
begin
   Result := GetHWndByPID(GetPIDByProgramName(APName));
end;

// Get Process Handle By Window Handle
function GetProcessHndByHWnd(const hWnd: THandle): THandle;
var
   PID: DWORD;
   AhProcess: THandle;
begin
   if hWnd <> 0 then
   begin
      GetWindowThreadProcessID(hWnd, @PID);
      AhProcess := OpenProcess(PROCESS_ALL_ACCESS, false, PID);
      Result := AhProcess;
      CloseHandle(AhProcess);
   end
   else
      Result := 0;
end;

// Get Process Handle By Process ID
function GetProcessHndByPID(const hAPID: THandle): THandle;
var
   AhProcess: THandle;
begin
   if hAPID <> 0 then
   begin
      AhProcess := OpenProcess(PROCESS_ALL_ACCESS, false, hAPID);
      Result := AhProcess;
      CloseHandle(AhProcess);
   end
   else
      Result := 0;
end;

// Get Window Handle By ProcessID
function GetPIDByHWnd(const hWnd: THandle): THandle;
var
   PID: DWORD;
begin
   if hWnd <> 0 then
   begin
      GetWindowThreadProcessID(hWnd, @PID);
      Result := PID;
   end
   else
      Result := 0;
end;

// Get Window Handle By ProcessID
function GetHWndByPID(const hPID: THandle): THandle;
type
   PEnumInfo = ^TEnumInfo;
   TEnumInfo = record
      ProcessID: DWORD;
      HWND: THandle;
   end;
   function EnumWindowsProc(Wnd: DWORD; var EI: TEnumInfo): Bool; stdcall;
   var
      PID: DWORD;
   begin
      GetWindowThreadProcessID(Wnd, @PID);
      Result := (PID <> EI.ProcessID) or
         (not IsWindowVisible(WND)) or
         (not IsWindowEnabled(WND));
      if not Result then EI.HWND := WND; //break on return FALSE
   end;

function FindMainWindow(PID: DWORD): DWORD;
   var
      EI: TEnumInfo;
   begin
      EI.ProcessID := PID;
      EI.HWND := 0;
      EnumWindows(@EnumWindowsProc, Integer(@EI));
      Result := EI.HWND;
   end;
begin
   if hPID <> 0 then
      Result := FindMainWindow(hPID)
   else
      Result := 0;
end;

// Get ProcessID By ProgramName (Include Path or Not Include)
function GetPIDByProgramName(const APName: string): THandle;
var
   isFound: boolean;
   AHandle, AhProcess: THandle;
   ProcessEntry32: TProcessEntry32;
   APath: array[0..MAX_PATH] of char;
begin
   Result := 0;
   AHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
   try
      ProcessEntry32.dwSize := Sizeof(ProcessEntry32);
      isFound := Process32First(AHandle, ProcessEntry32);
      while isFound do
      begin
         AhProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,
            false, ProcessEntry32.th32ProcessID);
         GetModuleFileNameEx(AhProcess, 0, @APath[0], sizeof(APath));
         if (UpperCase(StrPas(APath)) = UpperCase(APName)) or
            (UpperCase(StrPas(ProcessEntry32.szExeFile)) = UpperCase(APName)) then
         begin
            Result := ProcessEntry32.th32ProcessID;
            break;
         end;
         isFound := Process32Next(AHandle, ProcessEntry32);
         CloseHandle(AhProcess);
      end;
   finally
      CloseHandle(AHandle);
   end;
end;

// Activate a window by its handle
function AppActivate(WindowHandle: HWND): boolean; overload;
begin
   try
      SendMessage(WindowHandle, WM_SYSCOMMAND, SC_HOTKEY, WindowHandle);
      SendMessage(WindowHandle, WM_SYSCOMMAND, SC_RESTORE, WindowHandle);
      result := SetForegroundWindow(WindowHandle);
   except
      on Exception do Result := false;
   end;
end;


end.
