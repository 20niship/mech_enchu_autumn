function FindMother(j)
global link

if j ~= 0
    if j == 1
        link(j).mother = 0;
    end
    if link(j).child ~= 0  
        link(link(j).child).mother = j;
        FindMother(link(j).child);
    end
    if link(j).sister ~= 0
        link(link(j).sister).mother = link(j).mother;
        FindMother(link(j).sister);
    end
end