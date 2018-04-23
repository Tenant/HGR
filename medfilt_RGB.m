function im_out=medfilt_RGB(im_in, D)

    R=im_in(:,:,1);
    G=im_in(:,:,2);
    B=im_in(:,:,3);
    R=medfilt2(R,D);
    G=medfilt2(G,D);
    B=medfilt2(B,D);
    
    im_out(:,:,1)=R;
    im_out(:,:,2)=G;
    im_out(:,:,3)=B;

end