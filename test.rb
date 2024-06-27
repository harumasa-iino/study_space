def root(num)
    s_num = num.to_s
    s = 0
    e = 4
    s_num.size.times do 
      res = s_num.slice(s..e)
      i_res = res.to_i
      result = Math.sqrt(i_res)
      if result == result.to_i
        return result.to_i
      else
        s += 1
        e += 1
      end
    end
    return nil  
  end

num = 1415926535383832795028971693993
p root(num)