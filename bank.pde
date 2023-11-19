class Bank
{
	int cash;
	int level;
	int spinsLeft;

	Bank()
	{
		this.cash = 0;
		this.level = 0;
		this.spinsLeft = SPINS[this.level];
	}

	void mod(int amount)
	{
		this.cash += amount;
	}

	void didSpin()
	{
		this.spinsLeft--;
		if (this.spinsLeft <= 0)
		{
			if (bank.cash < PAYMENTS[this.level])
			{
				println("Lost!");
				init();
				return;
			}

			this.level++;
			if (this.level == PAYMENTS.length)
			{
				println("Won!");
				init();
				return;
			}

			this.spinsLeft = SPINS[this.level];
		}
	}
};
