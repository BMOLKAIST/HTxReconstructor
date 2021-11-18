function nom = normalization_shift(Img)
[ie, je] = size(Img);
%%
    b1=1;
    bsize=3;


    left=mean2(Img(:,b1:b1+bsize));
    right=mean2(Img(:, je-bsize-b1+1:je-b1+1));
    top=mean2(Img(b1:b1+bsize, 1:end));
    bottom=mean2(Img(ie-bsize-b1+1:ie-b1+1,:));

    px=(right-left)/je;
    py=(bottom-top)/ie;


    [XX, YY]=meshgrid(1:je,1:ie);
    nom=Img-(XX.*px+YY.*py);

end