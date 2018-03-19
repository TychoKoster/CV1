function [descriptor] = calculate_descriptors(I, f, channel)
I_ = vl_imsmooth(im2double(I(:,:,channel)), sqrt(f(3)^2 - 0.5^2));
[Ix, Iy] = vl_grad(I_);
mod = sqrt(Ix.^2 + Iy.^2);
ang = atan2(Iy,Ix);
grd = shiftdim(cat(3,mod,ang),2);
grd = single(grd);
descriptor = vl_siftdescriptor(grd, f);
end