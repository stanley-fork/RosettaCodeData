class BitArray : private Array<byte>
{
   uint64 bitSize;

   property uint64 size
   {
      set
      {
         bitSize = value;
         Array::size = (uint)((value + 7) >> 3);
      }
      get { return bitSize; }
   }

   bool check(uint64 n)
   {
      uint b = (uint)(n >> 3), s = (uint)(n & 7);
      return (bool)this[b] & (1 << s);
   }

   void explore(uint64 n)
   {
      uint b = (uint)(n >> 3), s = (uint)n & 7;
      this[b] |= (1 << s);
   }
}

class EratosthenesSieve
{
   BitArray isComposite { };

   uint64 limit;

   void sieve(uint64 limit)
   {
      this.limit = limit;

      if(limit >= 2)
      {
         uint64 i, j, m = (uint64)(sqrt((double)limit) + 0.1);

         isComposite.size = limit + 1;
         isComposite.explore(0);
         isComposite.explore(1);

         for(i = 2; i <= m; i++)
            if(!isComposite.check(i))
               for(j = i * i; j <= limit; j += i)
                  isComposite.explore(j);
      }
      else
         isComposite.Free();
   }

   void printPrimes()
   {
      if(!isComposite.count)
         PrintLn("No primes found within limit (", limit, ").");
      else
      {
         uint64 i, count = 0;

         for(i = 2; i <= limit; i++)
            if(!isComposite.check(i))
            {
               Print(i, " ");
               count++;
            }
         PrintLn("");
         PrintLn(count, " primes found up to ", limit);
      }
   }
}

class SieveOfEratosthenesApp : Application
{
   EratosthenesSieve sieve { };

   void Main()
   {
      sieve.sieve(argc > 1 ? (uint64)strtoull(argv[1], null, 10) : 100);
      sieve.printPrimes();
   }
}
