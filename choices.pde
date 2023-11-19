class Choices
{
	static final int MARGIN = 16;
	static final int HEIGHT = 160;
	static final int INTER_CHOICE = 16;

	Choices(int amount)
	{
		int w = (width - (Choices.MARGIN * 2 + Choices.INTER_CHOICE * (amount - 1))) / amount;

		for (int c = 0; c < amount; c++)
		{
			new ChoiceButton("Choice" + c, 	Choices.MARGIN + c * (w + Choices.INTER_CHOICE),
											TopBar.HEIGHT + BOARD_HEIGHT,
											w, Choices.HEIGHT,
											makeSymbol(symbolTable.getRandom()));
		}
	}
};
