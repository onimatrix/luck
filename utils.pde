static final color setAlpha(color original, int alpha)
{
  return (original & 0xffffff) | (alpha << 24);
}

String trim(float f)
{
	String t = nf(f, 0, 6);
	for (int c = t.length() - 1; c >= 0; c--)
	{
		char ch = t.charAt(c);
		if (ch == '.')
			return "" + int(f);
		if (ch != '0')
			return t.substring(0, c + 1);
	}
	return t;
}

Object createObject(String className)
{
  try
  {
  	Class<?> klass = Class.forName("luck$" + className);
    java.lang.reflect.Constructor constructor = klass.getDeclaredConstructor(getClass());
    return constructor.newInstance(this);
  }
  catch (Exception e) { e.printStackTrace(); }
  return null;
}
