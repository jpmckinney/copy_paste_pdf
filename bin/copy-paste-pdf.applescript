#!/usr/bin/osascript
-- @see http://appscript.sourceforge.net/osascript.html

on run argv
  set start to current date

  -- Default arguments.
  set close_applications to true

  -- Parse command-line arguments and translate paths from `/path/to/file.ext`
  -- to `Macintosh HD:path:to:file.ext`.
  set input to POSIX file (item 1 of argv) as alias
  set output to POSIX file (item 2 of argv) as string
  if count of argv is 2 then set close_applications to false

  tell application "Preview"
    activate
    open input
  end

  -- Preview is not fully scriptable.
  set the clipboard to ""
  tell application "System Events" to tell process "Preview"
    click menu item "Select All" of menu 1 of menu bar item "Edit" of menu bar 1
    click menu item "Copy" of menu 1 of menu bar item "Edit" of menu bar 1
  end tell
  if close_applications then tell application "Preview" to quit

  -- Yes, this is how to make AppleScript block.
  repeat
    try
      if (the clipboard) is not "" then
        -- One idea is to set a variable to the clipboard, in order to allow use
        -- of the clipboard by the user past this point. However, the clipboard
        -- to be complex based on the output of `return clipboard info`.
        exit repeat
      end if
    -- Calling `the clipboard` can sometimes cause an exception to be thrown,
    -- either due to race condition or software error. Not sure how to recover.
    -- Observed error codes are: -25130, -25132, -25133.
    -- @see http://search.cpan.org/~wyant/Mac-Pasteboard-0.002/lib/Mac/Pasteboard.pm#badPasteboardSyncErr
    -- @see http://search.cpan.org/~wyant/Mac-Pasteboard-0.002/lib/Mac/Pasteboard.pm#badPasteboardItemErr
    -- @see http://search.cpan.org/~wyant/Mac-Pasteboard-0.002/lib/Mac/Pasteboard.pm#badPasteboardFlavorErr
    on error error_message number error_number
      if {-25130, -25132, -25133} contains error_number
        error "Known error " & error_number & " occurred" number error_number
      else
        error error_message number error_number
      end if
    end try
  end repeat

  tell application "Microsoft Excel"
    activate
    make new workbook
    paste worksheet active sheet
    save workbook as active workbook filename output file format CSV file format overwrite yes
    close active workbook saving no
    if close_applications then quit
  end tell

  log "" & (current date - start) & " seconds"
end run
