public class Dog
{
   public Integer age;
    public String name;
    public String gender;
    public String breed;
    public Boolean isPuppy;
    public void bark()
    {
        System.debug('Woof, Woof!');
    }
    
    public void greeting()
    {
        System.debug('Hello, my name is ' + name);
    }
    
    public String retrieveDogInfo()
    {
        return 'Name: ' + name + '; Gender: ' + gender;
    }
}