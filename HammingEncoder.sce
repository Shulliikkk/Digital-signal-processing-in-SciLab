function out_seq=HemmingEncoder(in_seq, win)
    a=[0;0]
    posit = []
    
    //функция вставки новых значений в массив
    function out=insert_my(in, s, n, val)
        l = length(in)/(length(in_seq)/win)
        while l > n
            in(s, l) = in(s, l-1)
            l = l - 1
        end
        in(s, n) = val
        out = in
    endfunction
    
    //преобразование входного масссива битов в матрицу с количеством столбцов равным win
    for i=1:length(in_seq)/win
        for j=1:win
            a(i, j) = in_seq(j + win*(i-1))
        end
    end
    
    //создание массива с номерами позиций контрольных бит 
    n = 0
    while win >= 2^n
        posit(length(posit)+1) = 2^n
        n = n + 1
    end
    
    //добавление в конец каждой строки нулей
    for i=1:length(posit)
        a(1, length(a)/(length(in_seq)/win)+1) = 0
    end
    
    //вставка нулей на места контрольных бит
    for j=1:length(in_seq)/win
        for i=1:length(posit)
            a = insert_my(a, j, posit(i), 0)
        end
    end
    
    //подсчет и вставка контрольных бит
    len = length(a)/(length(in_seq)/win)'
    for h=1:length(in_seq)/win
        k = 1
        for j=1:length(posit)
            y = 0
            summ = 0
            for i=posit(j):2^k:len
                while y <= posit(j)-1
                    if i+y > len then
                        break
                    end
                    summ = summ + a(h, i+y)
                    y=y+1
                end
                y = 0
            end
        if modulo(summ, 2) == 0 then
            a(h, posit(j)) = 0
        else 
            a(h, posit(j)) = 1
        end
        k = k + 1
        end
    end
    
    //преобразование матрицы с битами обратно в массив
    out = []
    for i=1:length(in_seq)/win
        for j=1:len
            out(length(out)+1) = a(i, j)
        end
    end
    
    out_seq = out
endfunction