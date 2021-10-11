function output = onsection(P,A,B)

PA=A-P;
AB=B-A;
lambda=dot(PA,AB)/(norm(PA)*norm(AB));

if lambda>0
    output=-1;
else
    if lambda<0 && norm(PA)<norm(AB)
        output=0;
    else
        if lambda<0 && norm(PA)>norm(AB)
            output=1;
        end
    end
end

end
