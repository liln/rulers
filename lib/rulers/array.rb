class Array
  def sum(start = 0)
    inject(start, &:+)
  end

  def product(start = 1)
    inject(start, &:*)
  end
end
