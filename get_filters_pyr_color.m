function [filters_lo0filt, filters_hi0filt,filters_lofilt,filters_bfilts] = get_filters_pyr_color(lo0filt,hi0filt,lofilt,bfilts,numChannel)



[lo0filt1,hi0filt1,lofilt1,bfilts1] = createPyr_color(lo0filt,hi0filt,lofilt, bfilts,'positive');
[lo0filt2,hi0filt2,lofilt2,bfilts2] = createPyr_color(lo0filt,hi0filt,lofilt, bfilts,'negative');



lo0filt_col = zeros(size(lo0filt,1),size(lo0filt,2),2);
hi0filt_col = zeros(size(hi0filt,1),size(hi0filt,2),2);
lofilt_col = zeros(size(lofilt,1),size(lofilt,2),2);
bfilts_col = zeros(size(bfilts,1),size(bfilts,2),2);

%seperate to pos and neg parts
% for j=1:Nfilters
    lo0filt_col(:,:,1) = abs(lo0filt1);    hi0filt_col(:,:,1) = abs(hi0filt1);    lofilt_col(:,:,1) = abs(lofilt1); bfilts_col(:,:,1) = abs(bfilts1);
    lo0filt_col(:,:,2) = abs(lo0filt2);    hi0filt_col(:,:,2) = abs(hi0filt2);    lofilt_col(:,:,2) = abs(lofilt2); bfilts_col(:,:,1) = abs(bfilts2);
% end


if numChannel == 8
    weights = [1/sqrt(2),-1/sqrt(2),0; 2/sqrt(6),-1/sqrt(6),-1/sqrt(6); 1/sqrt(6),1/sqrt(6),-2/sqrt(6); 1/sqrt(3),1/sqrt(3),1/sqrt(3)]';
else if numChannel == 6;
        weights = [1/sqrt(2),-1/sqrt(2),0; 2/sqrt(6),-1/sqrt(6),-1/sqrt(6); 1/sqrt(6),1/sqrt(6),-2/sqrt(6)]';
    end
end

% weights = [1,-1,0;1,-1,-1;1,1,-1;1,1,1]';
weights = [weights , -weights];


filters_lo0filt = zeros(size(lo0filt,1),size(lo0filt,2), 3, 8);
filters_hi0filt = zeros(size(hi0filt,1),size(hi0filt,2), 3, 8);
filters_lofilt = zeros(size(lofilt,1),size(lofilt,2), 3, 8);
filters_bfilts = zeros(size(bfilts,1),size(bfilts,2), 3, 8);


for i=1:3
    for j=1:numChannel
        if weights(i,j) > 0
            %take the positive gabor
            hh = 1;
        elseif weights(i,j) < 0
            %take the negative gabor
            hh = 2;
        elseif weights(i,j) == 0
            hh = 1;
        end
        
        filters_lo0filt(:,:,i,j) =  weights(i,j) * lo0filt_col(:,:,hh);
        filters_hi0filt(:,:,i,j) =  weights(i,j) * hi0filt_col(:,:,hh);
        filters_lofilt(:,:,i,j) =  weights(i,j) * lofilt_col(:,:,hh);
        filters_bfilts(:,:,i,j) =  weights(i,j) * bfilts_col(:,:,hh);

    end
end



function [lo0filt,hi0filt,lofilt,bfilts] = createPyr_color(lo0filt,hi0filt,lofilt,bfilts,pyr_sign)

if strcmp(pyr_sign, 'positive')
    lo0filt(lo0filt<0) = 0;
    hi0filt(hi0filt<0) = 0;
    lofilt(lofilt<0) = 0;
    bfilts(bfilts<0) = 0;

elseif  strcmp(pyr_sign, 'negative')
    lo0filt(lo0filt>0) = 0;
    hi0filt(hi0filt>0) = 0;
    lofilt(lofilt>0) = 0;
    bfilts(bfilts>0) = 0;
end

return;

