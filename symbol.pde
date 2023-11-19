Symbol makeSymbol(String id)
{
	return (Symbol)createObject(id);
}

final color[] RARITY_COLORS = { #889D9D, #FFFFFF, #1EFF0C, #0070FF, #A335EE, #FF8000,  #E6CC80 };

class Symbol
{
	static final int SIZE = 64;
	PImage sprite;
	color col;
	String description;

	int x;
	int y;
	int scrX;
	int scrY;

	int baseCash;

	ArrayList<Symbol> affectedBy;
	ArrayList<Symbol> affected;

	int cash;
	float multiplier;

	Symbol(String pathToSymbol, color col, String description)
	{
		changeIcon(pathToSymbol);
		this.col = col;
		this.description = description;
		this.baseCash = 0;
		this.cash = 0;
		this.multiplier = 1.0f;

		this.affectedBy = new ArrayList<Symbol>();
		this.affected = new ArrayList<Symbol>();
	}

	void changeIcon(String pathToSymbol)
	{
		this.sprite = loadImage("icons/" + pathToSymbol);
	}

	boolean hovered()
	{
		return !(mouseX < this.scrX || mouseX >= this.scrX + Symbol.SIZE || mouseY < this.scrY || mouseY >= this.scrY + Symbol.SIZE);
	}

	String effectString()
	{
		if (this.baseCash == 0)
			return "";

		String str = "";
		if (this.cash > 0)
			str += "$" + int(this.cash * this.multiplier);
		else
			str += "$" + int(-this.cash * this.multiplier);
		if (abs(this.multiplier - 1.0f) > EPSILON)
			str += " (x" + trim(this.multiplier) + ")";
		return str;
	}

	void placeAt(Board board, int x, int y)
	{
		this.x = x;
		this.y = y;
		this.scrX = board.getSymbolX(this.x);
		this.scrY = board.getSymbolY(this.y);

		board.symbols[this.x][this.y] = this;
		board.symbolList.add(this);
		prepare();
	}

	void prepare()
	{
		this.multiplier = 1.0f;
		this.cash = this.baseCash;
		this.affectedBy.clear();
		this.affected.clear();
	}

	void affect()
	{
	}

	void earn()
	{
		if (this.cash == 0)
			return;

		bank.mod(int(this.cash * this.multiplier));

		if (this.cash > 0)
			feedback(effectString(), #FFFFFF);
		else
			feedback(effectString(), #FF0000);
	}

	void feedback(String text, color col)
	{
		tallyFeedbacks.add(new TallyFeedback(this.scrX + Symbol.SIZE / 2, this.scrY, text, col));
	}

	void draw()
	{
		tint(this.col);
		image(this.sprite, this.scrX, this.scrY);
	}

	void drawTallied()
	{
		tint(this.col);
		image(this.sprite, this.scrX, this.scrY - Board.INTER_SYMBOL / 2);
	}

	void drawEffect()
	{
		fill(255);
		textAlign(RIGHT, TOP);
		text(effectString(), this.scrX + Symbol.SIZE - 2, this.scrY + 2);
	}

	void drawAffected(Symbol affectedBy)
	{
		if (this.baseCash == 0)
			return;

		fill(255);
		textAlign(RIGHT, TOP);
		text(affectedBy.effectString(), this.scrX + Symbol.SIZE - 2, this.scrY + 2);
	}

	void drawAffectedBy()
	{
		fill(255);
		textAlign(RIGHT, TOP);
		text(effectString(), this.scrX + Symbol.SIZE - 2, this.scrY + 2);
	}

	void drawChoice(int x, int y, int w, int h)
	{
		tint(this.col);
		image(this.sprite, x + (w - this.sprite.width) / 2, y + Board.INTER_SYMBOL);

		textFont(small);
		textLeading(16);

		textAlign(CENTER, TOP);
		fill(255);
		text(this.description, x + w / 2, y + Board.INTER_SYMBOL + Symbol.SIZE + 5);
	}
};

class Empty extends Symbol
{
	Empty()
	{
		super("empty.png", #FFFFFF, "Nothing!");
	}

	void drawTallied()
	{
		draw();
	}
};

class Plus1 extends Symbol
{
	Plus1()
	{
		super("coin.png", #FFD700, "Earn $1");
		this.baseCash = 1;
	}
};

class Plus2 extends Symbol
{
	Plus2()
	{
		super("two_coins.png", #FFD700, "Earn $2");
		this.baseCash = 2;
	}
};

class Plus5 extends Symbol
{
	Plus5()
	{
		super("banknote.png", #85BB65, "Earn $5");
		this.baseCash = 5;
	}
};

class AppleTree extends Symbol
{
	static final int CYCLE = 5;
	int counter;
	AppleTree()
	{
		super("apple_tree.png", #228B22, "Earn $1\nEvery " + AppleTree.CYCLE + " turns\nSpawns Apple");
		this.baseCash = 1;
		this.counter = AppleTree.CYCLE;
	}

	String effectString()
	{
		String str = "";
		if (this.cash > 0)
			str += "$" + int(this.cash * this.multiplier);
		else
			str += "$" + int(-this.cash * this.multiplier);
		if (abs(this.multiplier - 1.0f) > EPSILON)
			str += " (x" + trim(this.multiplier) + ")";

		str += "\n";

		if (this.counter == 0)
			str += "Apple!";
		else
			str += "" + this.counter + "...";
		return str;
	}

	void earn()
	{
		this.counter--;
		if (this.counter == 0)
			inventory.add("Apple");

		super.earn();

		if (this.counter == 0)
			this.counter = AppleTree.CYCLE;
	}
};

class Apple extends Symbol
{
	static final int CYCLE = 5;
	int counter;

	Apple()
	{
		super("apple.png", #C7372F, "Earn $1\nRots in " + Apple.CYCLE + " turns");
		this.baseCash = 1;
		this.counter = Apple.CYCLE;
	}

	String effectString()
	{
		String str = "";
		if (this.cash > 0)
			str += "$" + int(this.cash * this.multiplier);
		else
			str += "$" + int(-this.cash * this.multiplier);
		if (abs(this.multiplier - 1.0f) > EPSILON)
			str += " (x" + trim(this.multiplier) + ")";
		str += "\n";
		if (this.counter == 0)
			str += "Rotten!";
		else
			str += "" + this.counter + "...";
		return str;
	}

	void earn()
	{
		this.counter--;
		if (this.counter == 0)
			inventory.remove("Apple");

		super.earn();
	}
};

class Die6 extends Symbol
{
	Die6()
	{
		super("d6_6.png", #CFB53B, "Roll D6\nEarn Value");
	}

	void prepare()
	{
		this.baseCash = int(floor(random(6))) + 1;
		changeIcon("d6_" + this.baseCash + ".png");

		super.prepare();
	}
};


class NorthX2 extends Symbol
{
	NorthX2()
	{
		super("north.png", #8C7853, "Doubles\nNorthwards");
	}

	String effectString()
	{
		return "x2";
	}

	void affect()
	{
		for (int y = this.y - 1; y >= 0; y--)
		{
			Symbol s = board.symbols[this.x][y];
			if (s.baseCash == 0)
				continue;
			s.multiplier *= 2.0f;
			s.affectedBy.add(this);
			this.affected.add(s);
		}
	}
};

class NorthX3 extends Symbol
{
	NorthX3()
	{
		super("north.png", #E6E8FA, "Triples\nNorthwards");
	}

	String effectString()
	{
		return "x3";
	}

	void affect()
	{
		for (int y = this.y - 1; y >= 0; y--)
		{
			Symbol s = board.symbols[this.x][y];
			if (s.baseCash == 0)
				continue;
			s.multiplier *= 3.0f;
			s.affectedBy.add(this);
			this.affected.add(s);
		}
	}
};

class NorthX5 extends Symbol
{
	NorthX5()
	{
		super("north.png", #CFB53B, "Quintuples\nNorthwards");
	}

	String effectString()
	{
		return "x5";
	}

	void affect()
	{
		for (int y = this.y - 1; y >= 0; y--)
		{
			Symbol s = board.symbols[this.x][y];
			if (s.baseCash == 0)
				continue;
			s.multiplier *= 5.0f;
			s.affectedBy.add(this);
			this.affected.add(s);
		}
	}
};

class SouthX2 extends Symbol
{
	SouthX2()
	{
		super("south.png", #8C7853, "Doubles\nSouthwards");
	}

	String effectString()
	{
		return "x2";
	}

	void affect()
	{
		for (int y = this.y + 1; y < Board.ROWS; y++)
		{
			Symbol s = board.symbols[this.x][y];
			if (s.baseCash == 0)
				continue;
			s.multiplier *= 2.0f;
			s.affectedBy.add(this);
			this.affected.add(s);
		}
	}
};

class SouthX3 extends Symbol
{
	SouthX3()
	{
		super("south.png", #E6E8FA, "Triples\nSouthwards");
	}

	String effectString()
	{
		return "x3";
	}

	void affect()
	{
		for (int y = this.y + 1; y < Board.ROWS; y++)
		{
			Symbol s = board.symbols[this.x][y];
			if (s.baseCash == 0)
				continue;
			s.multiplier *= 3.0f;
			s.affectedBy.add(this);
			this.affected.add(s);
		}
	}
};

class SouthX5 extends Symbol
{
	SouthX5()
	{
		super("south.png", #CFB53B, "Quintuples\nSouthwards");
	}

	String effectString()
	{
		return "x5";
	}

	void affect()
	{
		for (int y = this.y + 1; y < Board.ROWS; y++)
		{
			Symbol s = board.symbols[this.x][y];
			if (s.baseCash == 0)
				continue;
			s.multiplier *= 5.0f;
			s.affectedBy.add(this);
			this.affected.add(s);
		}
	}
};

class WestX2 extends Symbol
{
	WestX2()
	{
		super("west.png", #8C7853, "Doubles\nWestwards");
	}

	String effectString()
	{
		return "x2";
	}

	void affect()
	{
		for (int x = this.x - 1; x >= 0; x--)
		{
			Symbol s = board.symbols[x][this.y];
			if (s.baseCash == 0)
				continue;
			s.multiplier *= 2.0f;
			s.affectedBy.add(this);
			this.affected.add(s);
		}
	}
};

class WestX3 extends Symbol
{
	WestX3()
	{
		super("west.png", #E6E8FA, "Triples\nWestwards");
	}

	String effectString()
	{
		return "x3";
	}

	void affect()
	{
		for (int x = this.x - 1; x >= 0; x--)
		{
			Symbol s = board.symbols[x][this.y];
			if (s.baseCash == 0)
				continue;
			s.multiplier *= 3.0f;
			s.affectedBy.add(this);
			this.affected.add(s);
		}
	}
};

class WestX5 extends Symbol
{
	WestX5()
	{
		super("west.png", #CFB53B, "Quintuples\nWestwards");
	}

	String effectString()
	{
		return "x5";
	}

	void affect()
	{
		for (int x = this.x - 1; x >= 0; x--)
		{
			Symbol s = board.symbols[x][this.y];
			if (s.baseCash == 0)
				continue;
			s.multiplier *= 5.0f;
			s.affectedBy.add(this);
			this.affected.add(s);
		}
	}
};

class EastX2 extends Symbol
{
	EastX2()
	{
		super("east.png", #8C7853, "Doubles\nEastwards");
	}

	String effectString()
	{
		return "x2";
	}

	void affect()
	{
		for (int x = this.x + 1; x < Board.COLUMNS; x++)
		{
			Symbol s = board.symbols[x][this.y];
			if (s.baseCash == 0)
				continue;
			s.multiplier *= 2.0f;
			s.affectedBy.add(this);
			this.affected.add(s);
		}
	}
};

class EastX3 extends Symbol
{
	EastX3()
	{
		super("east.png", #E6E8FA, "Triples\nEastwards");
	}

	String effectString()
	{
		return "x3";
	}

	void affect()
	{
		for (int x = this.x + 1; x < Board.COLUMNS; x++)
		{
			Symbol s = board.symbols[x][this.y];
			if (s.baseCash == 0)
				continue;
			s.multiplier *= 3.0f;
			s.affectedBy.add(this);
			this.affected.add(s);
		}
	}
};

class EastX5 extends Symbol
{
	EastX5()
	{
		super("east.png", #CFB53B, "Quintuples\nEastwards");
	}

	String effectString()
	{
		return "x5";
	}

	void affect()
	{
		for (int x = this.x + 1; x < Board.COLUMNS; x++)
		{
			Symbol s = board.symbols[x][this.y];
			if (s.baseCash == 0)
				continue;
			s.multiplier *= 5.0f;
			s.affectedBy.add(this);
			this.affected.add(s);
		}
	}
};
