class Loot
{
	String id;
	double weight;

	Loot(String id, double weight)
	{
		this.id = id;
		this.weight = weight;
	}
};

class LootTable
{
	ArrayList<Loot> loot;
	double totalWeigth;

	LootTable()
	{
		this.loot = new ArrayList<Loot>();
		this.totalWeigth = 0.0;
	}

	void add(String id, double weight)
	{
		this.loot.add(new Loot(id, weight));
		this.totalWeigth += weight;
	}

	String getRandom()
	{
		double r = Math.random() * this.totalWeigth;
        double countWeight = 0.0;
        for (Loot l : this.loot)
        {
            countWeight += l.weight;
            if (countWeight > r)
                return l.id;
        }
        println("Oh fu @ LootTable::getRandom");
        return null;
	}
};
