ArrayList<TallyFeedback> tallyFeedbacks;
ButtonManager buttons;

Bank bank;
Inventory inventory;
Board board;
TopBar topBar;
SpinButton spinButton;

LootTable symbolTable;

final int[] PAYMENTS = { 25, 50, 100, 200, 500, 1000 };
final int[] SPINS = { 4, 4, 4, 5, 6, 7 };

final int BOARD_WIDTH = Board.MARGIN * 2 + Symbol.SIZE * Board.COLUMNS + Board.INTER_SYMBOL * (Board.COLUMNS - 1);
final int BOARD_HEIGHT = Board.MARGIN * 2 + Symbol.SIZE * Board.ROWS + Board.INTER_SYMBOL * (Board.ROWS - 1);

public enum States
{
	WAITING,
	SPINNING,
	AFFECTING,
	TALLYING,
	CHOOSING
};

States state;
PFont small;
PFont medium;
PFont large;

void settings()
{
	size(BOARD_WIDTH, TopBar.HEIGHT + BOARD_HEIGHT + Choices.HEIGHT);
}

void setup()
{
	small = createFont("PixelGamingRegular-d9w0g.ttf", 18);
	medium = createFont("PixelGamingRegular-d9w0g.ttf", 20);
	large = createFont("PixelGamingRegular-d9w0g.ttf", 48);
	textLeading(4);

	init();
}

void draw()
{
	background(32);

	board.update();

	topBar.draw();
	board.draw();

	buttons.draw();

	ArrayList<TallyFeedback> toRemove = new ArrayList<TallyFeedback>();
	for (TallyFeedback tf : tallyFeedbacks)
	{
		tf.draw();
		if (tf.life == 0)
			toRemove.add(tf);
	}
	tallyFeedbacks.removeAll(toRemove);
}

void init()
{
	state = States.WAITING;

	tallyFeedbacks = new ArrayList<TallyFeedback>();

	bank = new Bank();
	inventory = new Inventory();
	board = new Board();
	topBar = new TopBar();

	buttons = new ButtonManager();
	new SpinButton("Spin", 0, TopBar.HEIGHT + BOARD_HEIGHT, width, Choices.HEIGHT);

	symbolTable = new LootTable();
	symbolTable.add("Plus1", 10.0);
	symbolTable.add("Plus2", 3.0);
	symbolTable.add("Apple", 3.0);
	symbolTable.add("Die6", 2.0);
	symbolTable.add("AppleTree", 2.0);
	symbolTable.add("Plus5", 1.0);
	symbolTable.add("NorthX2", 0.5);
	symbolTable.add("NorthX3", 0.1);
	symbolTable.add("NorthX5", 0.05);
	symbolTable.add("SouthX2", 0.5);
	symbolTable.add("SouthX3", 0.1);
	symbolTable.add("SouthX5", 0.05);
	symbolTable.add("WestX2", 0.5);
	symbolTable.add("WestX3", 0.1);
	symbolTable.add("WestX5", 0.05);
	symbolTable.add("EastX2", 0.5);
	symbolTable.add("EastX3", 0.1);
	symbolTable.add("EastX5", 0.05);
}

boolean leftPressed = false;
void mousePressed()
{
	if (mouseButton == LEFT)
	{
		if (leftPressed == false)
			buttons.press();
		leftPressed = true;
	}
}

void mouseReleased()
{
	if (mouseButton == LEFT)
	{
		if (leftPressed)
		{
			leftPressed = false;
			buttons.release();
		}
	}
}
