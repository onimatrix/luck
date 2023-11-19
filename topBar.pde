class TopBar
{
	static final int HEIGHT = 32;

	void draw()
	{
		noStroke();
		fill(64);
		rect(0, 0, width, TopBar.HEIGHT);

		textFont(medium);

		textAlign(LEFT, CENTER);
		if (bank.cash >= PAYMENTS[bank.level])
			fill(64, 255, 64);
		else
			fill(255);
		text("$ " + bank.cash + "/" + PAYMENTS[bank.level], 10, TopBar.HEIGHT / 2);

		fill(255);
		textAlign(CENTER, CENTER);
		text("Level " + (bank.level + 1) + "/" + (PAYMENTS.length + 1), width / 2, TopBar.HEIGHT / 2);
		textAlign(RIGHT, CENTER);
		text("Spin " + (SPINS[bank.level] - bank.spinsLeft) + "/" + SPINS[bank.level], width - 10, TopBar.HEIGHT / 2);
	}
};
