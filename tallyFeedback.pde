class TallyFeedback
{
	static final int LIFETIME = 120;

	int x;
	int y;
	String text;
	color col;

	int life;

	TallyFeedback(int x, int y, String text, color col)
	{
		this.x = x;
		this.y = y;
		this.text = text;
		this.col = col;

		this.life = TallyFeedback.LIFETIME;
	}

	void draw()
	{
		textAlign(CENTER, CENTER);
		textFont(medium);

		int xx = this.x;
		int yy = this.y - (TallyFeedback.LIFETIME - this.life) / 3;

		fill(0, map(this.life, TallyFeedback.LIFETIME, 0, 255, 0));
		text(this.text, xx + 1, yy + 1);

		int alpha = int(map(this.life, TallyFeedback.LIFETIME, 0, 255, 0));
		fill(setAlpha(this.col, alpha));
		text(this.text, xx, yy);

		this.life--;
	}
};
