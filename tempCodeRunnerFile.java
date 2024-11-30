class Abc
{
    public static void main(String[] args) 
    {
        try
        {
            // system.exit(0);
            System.out.println("Hello, World!");
        }
        catch (Exception e)
        {
            System.out.println(e);
        }
        finally
        {
            System.out.println("Hello, World!");
        }

    }
}