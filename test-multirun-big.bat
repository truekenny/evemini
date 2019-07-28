for /l %%x in (1, 1, 100) do (
   start Win32\Debug\Evemini --window-name="Calculator1" --form-top=400 --form-left=400 --form-width=90 --always-visible=true
)
pause
