class String
  def rjust(idx, padstr = ' ')
    if idx <= self.size
      return self
    end
    newstr = self.dup
    newstr.prepend(padstr)
    while newstr.size <= idx
      newstr.prepend(padstr)
    end
    return newstr.slice(0,idx)
  end
end
