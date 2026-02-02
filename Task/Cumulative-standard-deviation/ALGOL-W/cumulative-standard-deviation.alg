begin

    record CSD ( long real sumof, sum2of, sdof; integer countof );

    long real procedure sample ( reference(CSD) value sdv; long real value x) ;
    begin
        long real sum, sum2;
        integer   n;

        countof(sdv) := countof(sdv) + 1;
        sum          := sumof(sdv);
        sum2         := sum2of(sdv);
        n            := countof(sdv);
        sum          := sum   + x;
        sum2         := sum2  + (x*x);
        sdof(sdv)    := if n = 0 then 0 else longsqrt(sum2/n - sum*sum/n/n);
        sumof(sdv)   := sum;
        sum2of(sdv)  := sum2;
        sdof(sdv)
    end sample;

    reference(CSD) procedure NewCSD; CSD( 0, 0, 0, 0 );

    begin
        reference(CSD) sd;

        sd := NewCSD;
        r_format := "A"; r_w := 14; r_d := 6; % set output to fixed point format %
        i_w := 6; s_w := 0;              % also set integer and separator format %
        for i := 2,4,4,4,5,5,7,9 do begin
            long real val, newSd;
            val := i;
            newSd := sample( sd, val );
            write( countof(sd), ": ", val, " -> ", newSd )
        end for_i
    end
end.
