# Copy-Paste PDF

[![Build Status](https://secure.travis-ci.org/opennorth/copy_paste_pdf.png)](http://travis-ci.org/opennorth/copy_paste_pdf)
[![Dependency Status](https://gemnasium.com/opennorth/copy_paste_pdf.png)](https://gemnasium.com/opennorth/copy_paste_pdf)
[![Coverage Status](https://coveralls.io/repos/opennorth/copy_paste_pdf/badge.png?branch=master)](https://coveralls.io/r/opennorth/copy_paste_pdf)
[![Code Climate](https://codeclimate.com/github/opennorth/copy_paste_pdf.png)](https://codeclimate.com/github/opennorth/copy_paste_pdf)

[Tabula](https://github.com/jazzido/tabula) was written for those cases where you can’t easily copy-and-paste tables from a PDF to a spreadsheet. Surprisingly, Tabula sometimes fails where copy-and-pasting succeeds. This project is for [those cases](http://www.atipp.gov.nl.ca/info/coordinators.html) when copy-and-pasting is all you need (and where nothing else works).

This gem only works on OS X.

## Getting Started

### PDF to CSV

Install with:

    gem install --no-wrappers copy_paste_pdf

If you omit the `--no-wrappers` switch, the AppleScript will not install properly. You may run the script with:

    copy-paste-pdf.applescript /path/to/input.pdf /path/to/output.csv

* The script will open the PDF in Preview and copy the contents of the PDF
* The script will open Microsoft Excel, paste the contents and save as CSV

If you want the script to quit Preview and Excel once it's done, pass a third argument, like:

    copy-paste-pdf.applescript /path/to/input.pdf /path/to/output.csv true

The script may [pinwheel](http://en.wikipedia.org/wiki/Spinning_pinwheel) while copying the contents of the PDF and while pasting the contents to the spreadsheet. If it looks like nothing is happening, wait a few seconds.

You can work in other applications while the script is running - just don't use the clipboard as it may interfere with the script.

This method is admittedly not very efficient. Running time averages under 2 seconds per page but varies considerably depending on your system's load.

### Data Cleaning

The Ruby gem defines helper methods for cleaning the CSV. In most cases, the PDF to CSV conversion will create many empty rows. You can easily remove those rows with:

```ruby
require 'csv'

require 'copy_paste_pdf'

table = CopyPastePDF::Table.new(CSV.read('/path/to/output.csv'))

table.remove_empty_rows!

CSV.open('/path/to/clean.csv', 'w') do |csv|
  table.each do |row|
    csv << row
  end
end
```

If the table in the PDF contained vertically-merged cells, then, in the CSV, the first of the merged cells will have a value and the others will be empty. To copy the value of the first cell to the others, use the `copy_into_cell_below` method, which accepts the indices of columns containing merged cells:

```ruby
table.copy_into_cell_below(0, 3, 4)
```

Sometimes, if a cell contains multiple lines of text, the PDF to CSV conversion will incorrectly break the cell into multiple rows. To remove the spurious row and merge its values into the row above, use the `merge_into_cell_above` method, which accepts the indices of columns in which this error occurs:

```ruby
table.merge_into_cell_above(1, 2)
```

With additional time and effort, these two methods can be made to operate without needing columns as hints.

## Troubleshooting

If you see warnings on the command-line like:

    2013-10-09 14:30:03.704 osascript[2056:707] Error loading /Library/ScriptingAdditions/Adobe Unit Types.osax/Contents/MacOS/Adobe Unit Types:  dlopen(/Library/ScriptingAdditions/Adobe Unit Types.osax/Contents/MacOS/Adobe Unit Types, 262): no suitable image found.  Did find:
      /Library/ScriptingAdditions/Adobe Unit Types.osax/Contents/MacOS/Adobe Unit Types: no matching architecture in universal wrapper
    osascript: OpenScripting.framework - scripting addition "/Library/ScriptingAdditions/Adobe Unit Types.osax" declares no loadable handlers.

See [this Adobe help article](http://helpx.adobe.com/photoshop/kb/unit-type-conversion-error-applescript.html).

## Developers

If, like me, you almost never write AppleScript, you can access much of AppleScript's documentation through Apple's AppleScript Editor. See, for example, how to access [the entries about Microsoft Excel](http://support.microsoft.com/kb/113891).

## Why?

Most of the PDFs I work with contain no tables. In those cases I either:

* Run `pdftotext filename.pdf` to convert the PDF to text, and write a script using regular expressions to parse the output.
* Run `pdftotext -layout filename.pdf` to convert the PDF to text while preserving the text layout – very useful when working with two-column layouts.
* Use [commercial software](http://reviews.reporterslab.org/search?q=&type=products&category=pdf-tools-2011-11-09) like Adobe Acrobat Pro to save the PDF to another format, usually Excel.
* I recently learned that Apple's Automator has an `Extract PDF Text` action which performs well.

For PDFs containing tables, I discovered that copy-pasting from Apple's Preview to Microsoft Excel worked better than all alternatives tested, for the PDFs I was interested in.

## Bugs? Questions?

This project's main repository is on GitHub: [http://github.com/opennorth/copy_paste_pdf](http://github.com/opennorth/copy_paste_pdf), where your contributions, forks, bug reports, feature requests, and feedback are greatly welcomed.

Copyright (c) 2013 Open North Inc., released under the MIT license
