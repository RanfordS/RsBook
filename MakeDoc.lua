jobname = "RSkyl"
repeats = 1

make_pdf = 'pdflatex --shell-escape --interaction=nonstopmode -jobname="'..jobname..'" Main.tex'
make_bib = "biber "..jobname
make_pdf_null = make_pdf.." > /dev/null"
make_bib_null = make_bib.." > /dev/null"

file = io.open ("RSkylToC.tex", "w")
file:write ("\\UNDEF")
file:close ()

print ("\n\27[1;4;33mDoing Repeat Builds\27[0m\n")
for i = 1, repeats do
    print ("iteration:", i)
    os.execute (make_pdf_null)
    os.execute (make_bib_null)
end

print ("\n\27[1;4;33mFinal Build Log\27[0m\n")
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

Clean = {"aux", "nlo", "out", "bbl", "bcf", "blg", "xml", "toc", "lof", "lot"}
for _, extension in ipairs (Clean) do
    os.execute ("rm -f *."..extension)
end
