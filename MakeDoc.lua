jobname = "RSkyl"
repeats = 1

make_pdf = 'lualatex --shell-escape --interaction=nonstopmode -jobname="'..jobname..'" Main.tex'
make_bib = "biber "..jobname
make_pdf_null = make_pdf.." > /dev/null"
make_bib_null = make_bib.." > /dev/null"

path_internal = "RSkylInternal/"
--contents_major_new = path_internal.."MajorContents.new"
contents_major_old = path_internal.."MajorContents.tex"

--file = io.open ("RSkylToC.tex", "w")
--file:write ("\\UNDEF")
--file:close ()

--file = io.open (contents_major_old, "w")
--file:write ("\\UNDEF")
--file:close ()

os.execute ("rm ".. contents_major_old)

print ("\n\27[1;4;33mDoing Repeat Builds\27[0m\n")
for i = 1, repeats do
    --Iter_file_make (i)
    print ("iteration:", i)
    os.execute (make_pdf_null)
    os.execute (make_bib_null)
    local tocs_file = io.popen ("ls -1 RSkylInternal/*.new")
    for line in tocs_file:lines () do
        line = line:sub (0, -5)
        os.execute (("mv %s.new %s.tex"):format (line, line))
    end
end

print ("\n\27[1;4;33mFinal Build Log\27[0m\n")
--Iter_file_make (repeats + 1)
res = io.popen (make_pdf)
txt = res:read ("*a")
res:close ()
print ("\27[3m"..txt.."\27[0m")

print ("\n\27[1;4;33mLaTeX Warnings:\27[0m\n")
for warn in txt:gmatch ("! (.-)\n\n") do
    print ("\27[1;35m"..warn.."\27[0m\n")
end

print ("\n\27[1;4;33mTODO:\27[0m\n")
for warn in txt:gmatch ("Package TODO Warning: (.-)%.") do
    print ("\27[1;35m"..warn:gsub('\n','').."\27[0m\n")
end

Clean = {"aux", "nlo", "out", "bbl", "bcf", "blg", "xml", "toc", "lof", "lot", 'mx1', 'ly'}
for _, extension in ipairs (Clean) do
    os.execute ("rm -f *."..extension)
end
os.execute ("rm -r RSkylInternal/*")
