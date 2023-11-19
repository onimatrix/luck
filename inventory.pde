class Inventory
{
	ArrayList<Symbol> symbols;
	int emptyAmount;

	Inventory()
	{
		this.symbols = new ArrayList<Symbol>();
		this.emptyAmount = 20;

		addMultiple("Empty", Board.COLUMNS * Board.ROWS);
		addMultiple("Plus1", 5);
	}

	void add(Symbol symbol)
	{
		if (symbol instanceof Empty == false)
		{
			if (this.emptyAmount > 0)
			{
				this.symbols.add((Board.COLUMNS * Board.ROWS) - this.emptyAmount, symbol);
				remove("Empty");
				this.emptyAmount--;
				return;
			}
		}

		//println("Adding " + symbolClassName);
		this.symbols.add(symbol);
	}

	void add(String symbolClassName)
	{
		add(makeSymbol(symbolClassName));
	}

	void addMultiple(String symbolClassName, int amount)
	{
		//println("Adding " + symbolClassName + " x" + amount);
		for (int i = 0; i < amount; i++)
			add(symbolClassName);
	}

	void addUpTo(String symbolClassName, int until)
	{
		int amountToAdd = until - this.symbols.size();
		addMultiple(symbolClassName, amountToAdd);
	}

	void remove(String symbolClassName)
	{
		Symbol s = makeSymbol(symbolClassName);
		for (Symbol ss : this.symbols)
		{
			if (ss.getClass() == s.getClass())
			{
				this.symbols.remove(ss);
				return;
			}
		}
		println("Oh fu @ Inventory::remove, no symbol of " + symbolClassName + " type!");
	}
};
