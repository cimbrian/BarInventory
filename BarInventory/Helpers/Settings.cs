namespace BarInventory.Helpers;
public class Settings
{

    public string BarDBConnection { get; set; } = "";
    
    public Settings(string barDBConnection)
    {
        BarDBConnection = barDBConnection;
        
    }

}
