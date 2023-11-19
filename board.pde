class Board
{
	static final int MARGIN = 64;
	static final int INTER_SYMBOL = 8;

	static final int COLUMNS = 5;
	static final int ROWS = 4;

	Symbol[][] symbols;
	ArrayList<Symbol> symbolList;
	int currentSymbol;

	ArrayList<Symbol> symbolsToPlace;
	int symbolsLeftToPlace;

	Board()
	{
		clear();

		inventory.symbols.get(0).placeAt(this, 0, 1);
		inventory.symbols.get(1).placeAt(this, 1, 2);
		inventory.symbols.get(2).placeAt(this, 2, 1);
		inventory.symbols.get(3).placeAt(this, 3, 2);
		inventory.symbols.get(4).placeAt(this, 4, 1);

		inventory.symbols.get(5).placeAt(this, 0, 0);
		inventory.symbols.get(6).placeAt(this, 0, 2);
		inventory.symbols.get(7).placeAt(this, 0, 3);

		inventory.symbols.get(8).placeAt(this, 1, 0);
		inventory.symbols.get(9).placeAt(this, 1, 1);
		inventory.symbols.get(10).placeAt(this, 1, 3);

		inventory.symbols.get(11).placeAt(this, 2, 0);
		inventory.symbols.get(12).placeAt(this, 2, 2);
		inventory.symbols.get(13).placeAt(this, 2, 3);

		inventory.symbols.get(14).placeAt(this, 3, 0);
		inventory.symbols.get(15).placeAt(this, 3, 1);
		inventory.symbols.get(16).placeAt(this, 3, 3);

		inventory.symbols.get(17).placeAt(this, 4, 0);
		inventory.symbols.get(18).placeAt(this, 4, 2);
		inventory.symbols.get(19).placeAt(this, 4, 3);
	}

	void clear()
	{
		this.symbols = new Symbol[Board.COLUMNS][Board.ROWS];
		this.symbolList = new ArrayList<Symbol>();
	}

	void prepareSpin()
	{
		clear();

		state = States.SPINNING;
		this.symbolsToPlace = new ArrayList<Symbol>(inventory.symbols);
		java.util.Collections.shuffle(this.symbolsToPlace);

		this.symbolsLeftToPlace = min(this.symbolsToPlace.size(), Board.COLUMNS * Board.ROWS);
	}

	void placeSymbol()
	{
		if (state != States.SPINNING)
			return;

		while (true)
		{
			int x = int(floor(random(Board.COLUMNS)));
			int y = int(floor(random(Board.ROWS)));

			if (this.symbols[x][y] == null)
			{
				this.symbolsLeftToPlace--;
				Symbol s = this.symbolsToPlace.get(this.symbolsLeftToPlace);
				s.placeAt(this, x, y);

				if (this.symbolsLeftToPlace == 0)
					affect();
				return;
			}
		}
	}

	void affectSymbol()
	{
		Symbol s = this.symbolList.get(this.currentSymbol++);
		s.affect();

		if (this.currentSymbol >= this.symbolList.size())
			tally();
	}

	void tallySymbol()
	{
		Symbol s = this.symbolList.get(this.currentSymbol++);
		s.earn();

		if (this.currentSymbol >= this.symbolList.size())
			finishSpin();
	}

	void spin()
	{
		prepareSpin();
	}

	void affect()
	{
		state = States.AFFECTING;
		this.currentSymbol = 0;
	}

	void tally()
	{
		state = States.TALLYING;
		this.currentSymbol = 0;
	}

	void finishSpin()
	{
		bank.didSpin();
		buttons.get("Spin").hide();
		state = States.CHOOSING;
		new Choices(3);
	}

	void update()
	{
		if (frameCount % 2 != 0)
			return;

		switch (state)
		{
			case SPINNING:
				placeSymbol();
				break;
			case AFFECTING:
				affectSymbol();
				break;
			case TALLYING:
				tallySymbol();
				break;
		}
	}

	int getSymbolX(int x)
	{
		return Board.MARGIN + x * (Symbol.SIZE + Board.INTER_SYMBOL);
	}

	int getSymbolY(int y)
	{
		return Board.MARGIN + TopBar.HEIGHT + y * (Symbol.SIZE + Board.INTER_SYMBOL);
	}

	Symbol hovered()
	{
		for (Symbol s : this.symbolList)
		{
			if (s.hovered())
				return s;
		}
		return null;
	}

	void draw()
	{
		Symbol hovered = hovered();

		for (Symbol s : this.symbolList)
		{
			if (state == States.TALLYING)
			{
				Symbol current = this.symbolList.get(this.currentSymbol);
				if (current.affectedBy.contains(s))
				{
					s.drawTallied();
					continue;
				}
			}

			if (state == States.TALLYING && s == this.symbolList.get(this.currentSymbol))
				s.drawTallied();
			else
				s.draw();

			if (state == States.WAITING && hovered != null)
			{
				if (hovered.affected.contains(s))
					s.drawAffected(hovered);
				if (hovered.affectedBy.contains(s))
					s.drawAffectedBy();
				if (hovered == s)
					s.drawEffect();
			}
		}
	}
};
