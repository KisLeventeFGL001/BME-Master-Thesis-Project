function output = onsection(P,A,B)

if A(1)>B(1)
    Larger_x=A(1);
    Smaller_x=B(1);
else
    Larger_x=B(1);
    Smaller_x=A(1);
end

if A(2)>B(2)
    Larger_y=A(2);
    Smaller_y=B(2);
else
    Larger_y=B(2);
    Smaller_y=A(2);
end

if A(3)>B(3)
    Larger_z=A(3);
    Smaller_z=B(3);
else
    Larger_z=B(3);
    Smaller_z=A(3);
end

Px=P(1);
Py=P(2);
Pz=P(3);

if Px>=Smaller_x && Px<=Larger_x
    output=0;
else
    if Py>=Smaller_y && Py<=Larger_y
        output=0;
    else
        if Py>=Smaller_y && Py<=Larger_y
            output=0;
        end
    end
end

if Px>=Smaller_x && Px>=Larger_x
    if Larger_x==A(1)
        output=-1;
    else
        if Larger_x==B(1)
            output=1;
        end
    end
else
    if Py>=Smaller_y && Py>=Larger_y
        if Larger_y==A(2)
            output=-1;
        else
            if Larger_y==B(2)
                output=1;
            end
        end
    else
        if Pz>=Smaller_z && Pz>=Larger_z
            if Larger_z==A(3)
                output=-1;
            else
                if Larger_z==B(3)
                    output=1;
                end
            end
        end
    end
end

if Px<=Smaller_x && Px<=Larger_x
    if Smaller_x==A(1)
        output=-1;
    else
        if Smaller_x==B(1)
            output=1;
        end
    end
else
    if Py<=Smaller_y && Py<=Larger_y
        if Smaller_y==A(2)
            output=-1;
        else
            if Smaller_y==B(2)
                output=1;
            end
        end
    else
        if Pz<=Smaller_z && Pz<=Larger_z
            if Smaller_z==A(3)
                output=-1;
            else
                if Smaller_z==B(3)
                    output=1;
                end
            end
        end
    end
end

end

