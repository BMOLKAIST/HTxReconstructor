function flipped_stack = flip_stack(org_stack)
    flipped_stack = zeros(size(org_stack),'single');
    if ndims(org_stack)==4
        for i = 1:size(org_stack,1)
            for ii = 1:size(org_stack,4)
                flipped_stack(i,:,:,ii) = flipud((squeeze(org_stack(i,:,:,ii))));
            end
        end
    elseif ndims(org_stack)==3
        for i = 1:size(org_stack,1)
            flipped_stack(i,:,:) = flipud((squeeze(org_stack(i,:,:))));
        end
    end
end