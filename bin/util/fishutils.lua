-- FishUtils by Fisher (XMedders)!
-- fishermedders.com 2016

function cprint( y, text )
  size = { term.getSize() }
  term.setCursorPos( (size[1]/2)-(#text/2)+1, y)
  term.write(text)
end

function label( text, bcolor, tcolor )
  size = { term.getSize() }
  term.setCursorPos(1,1)
  term.setBackgroundColor(bcolor)
  for i = 1,size[1] do
    term.write(" ")
  end
  term.setCursorPos(1,size[2])
  for i = 1,size[1] do
    term.write(" ")
  end
  term.setTextColor( tcolor )
  cprint( 1, text )
end
