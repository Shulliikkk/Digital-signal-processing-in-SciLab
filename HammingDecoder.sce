//Декодирование кода Хемминга
function out_seq=HammingDecoder(in_seq, win)
    //Описание аргументов:
    //in_seg - входной массив с битами
    //win - длина блока кодирования
    a=[0;0]
    posit = []
    
    //создание массива, хранящего номера позиций контрольных бит 
    n = 0
    while win >= 2^n
        posit(length(posit)+1) = 2^n
        n = n + 1
    end
    
    //преобразование входного масссива в матрицу с количеством столбцов равным win + length(posit)
    for i=1:length(in_seq)/(length(posit)+win)
        for j=1:win
            a(i, j) = in_seq(j + win*(i-1))
        end
    end
    
    //вставка нулей на места контрольных бит
    for i=1:length(in_seq)/(length(posit)+win)
        for j=1:length(posit)
            a(i, posit(j)) = 0
        end
    end
    
    //подсчет и вставка контрольных бит
    len = length(posit)+win
    for h=1:length(in_seq)/(win+length(posit))
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
    
    //определение позиции искаженного бита
    for i=1:length(in_seq)/(length(posit)+win)
        summ = 0
        for j=1:length(posit)
            if a(i, posit(j)) ~= b(i, posit(j)) then 
                summ = summ + posit(j)
            end
        end
        
        //его исправление
        if a(i, summ) == 0 then
            a(i, summ) = 1
        else
            a(i, summ) = 0
        end
    end
    
    //преобразование матрицы с битами обратно в одномерный массив
    out = []
    for i=1:length(in_seq)/(length(posit) + win)
        for j=1:len
            out(length(out)+1) = a(i, j)
        end
    end
    
    out_seq = out
endfunction
