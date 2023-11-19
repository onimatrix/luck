class ButtonManager
{
	HashMap<String, Button> buttonsByID;
	ArrayList<Button> buttons;

	Button pressed;

	ButtonManager()
	{
		this.buttonsByID = new HashMap<String, Button>();
		this.buttons = new ArrayList<Button>();
	}

	Button get(String id)
	{
		return this.buttonsByID.get(id);
	}

	void press()
	{
		ArrayList<Button> temp = new ArrayList<Button>(this.buttons);
		for (Button b : temp)
		{
			if (b.visible && b.hovered())
			{
				this.pressed = b;
				this.pressed.press();
				return;
			}
		}
	}

	void release()
	{
		if (this.pressed != null)
		{
			this.pressed.release();
			this.pressed = null;
		}
	}

	void draw()
	{
		for (Button b : this.buttons)
			if (b.visible)
				b.draw();
	}
};

class Button
{
	int x;
	int y;
	int w;
	int h;
	String id;

	boolean visible;

	Button(String id, int x, int y, int w, int h)
	{
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.id = id;
		buttons.buttons.add(this);
		buttons.buttonsByID.put(this.id, this);

		this.visible = true;
	}

	void kill()
	{
		buttons.buttons.remove(this);
		buttons.buttonsByID.remove(this.id);
	}

	void show()
	{
		this.visible = true;
	}

	void hide()
	{
		this.visible = false;
	}

	boolean hovered()
	{
		return !(mouseX < this.x || mouseX >= this.x + this.w || mouseY < this.y || mouseY >= this.y + this.h);
	}

	void press()
	{
	}

	void release()
	{
		if (buttons.pressed == this)
			clicked();
	}

	void clicked()
	{
	}

	void draw()
	{
		noStroke();
		if (hovered())
		{
			if (buttons.pressed == this)
				fill(16);
			else
				fill(128);
		}
		else
			fill(64);

		rect(this.x, this.y, this.w, this.h);
	}
};

class SpinButton extends Button
{
	SpinButton(String id, int x, int y, int w, int h)
	{
		super(id, x, y, w, h);
	}

	void clicked()
	{
		if (state == States.WAITING)
		{
			hide();
			board.spin();
		}
	}

	void draw()
	{
		color bg;
		color fg;

		noStroke();
		if (state != States.WAITING)
			bg = color(64);
		else if (hovered())
		{
			if (buttons.pressed == this)
				bg = color(16);
			else
				bg = color(128);
		}
		else
			bg = color(64);

		if (state != States.WAITING)
			fg = color(128);
		else if (hovered())
		{
			if (buttons.pressed == this)
				fg = color(128);
			else
				fg = color(255);
		}
		else
			fg = color(192);

		fill(bg);
		rect(this.x, this.y, this.w, this.h);

		fill(fg);
		textAlign(CENTER, CENTER);
		textFont(large);
		text("SPIN", this.x + this.w / 2, this.y + this.h / 2);
	}
};

class ChoiceButton extends Button
{
	Symbol symbol;

	ChoiceButton(String id, int x, int y, int w, int h, Symbol symbol)
	{
		super(id, x, y, w, h);
		this.symbol = symbol;
	}

	void clicked()
	{
		inventory.add(this.symbol);
		buttons.get("Choice0").kill();
		buttons.get("Choice1").kill();
		buttons.get("Choice2").kill();
		buttons.get("Spin").show();

		state = States.WAITING;
	}

	void draw()
	{
		super.draw();

		if (hovered())
		{
			if (buttons.pressed == this)
				fill(128);
			else
				fill(255);
		}
		else
			fill(192);

		this.symbol.drawChoice(this.x, this.y, this.w, this.h);
	}
};
