begin

% return n mod m %
integer function mod(n, m);
integer n, m;
begin
  mod := n - m * (n / m);
end;


% return 1 if n is prime, otherwise 0 %
integer function isprime(n);
integer n;
begin
  if n = 2 then
    isprime := 1
  else if (n < 2) or (mod(n,2) = 0) then
    isprime := 0
  else % test odd numbers up to sqrt of n %
    begin
      integer i, divisors;
      i := 3;
      divisors := 0;
      while i * i <= n and divisors = 0 do
        begin
          if mod(n, i) = 0 then divisors := divisors + 1;
          i := i + 2;
        end;
      isprime := (if divisors = 0 then 1 else 0);
    end;
 end;

% test for primes in range 1 to 50 %
integer i;
write("");
for i := 1 step 1 until 50 do
  begin
    if isprime(i) = 1 then writeon(i,"  ");
  end;

end
