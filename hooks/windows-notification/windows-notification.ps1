# Windows Notification for Claude Code
# Uses WPF window centered on screen as notification

param(
    [string]$Title = "Claude Code",
    [string]$Message = "Task Completed"
)

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$xaml = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    WindowStyle="None"
    AllowsTransparency="True"
    Background="Transparent"
    Topmost="True"
    SizeToContent="WidthAndHeight"
    WindowStartupLocation="CenterScreen"
    ShowInTaskbar="False"
    ShowActivated="False"
    Opacity="0">
    <Border CornerRadius="10" Background="#1E1E2E" BorderBrush="#8B5CF6" BorderThickness="2" Padding="24,20">
        <Border.Effect>
            <DropShadowEffect Color="#8B5CF6" Opacity="0.5" BlurRadius="20" ShadowDepth="5"/>
        </Border.Effect>
        <StackPanel Orientation="Vertical" MaxWidth="400">
            <StackPanel Orientation="Horizontal">
                <TextBlock Text="&#x1F514;" FontSize="16" Margin="0,0,10,0" VerticalAlignment="Center"/>
                <TextBlock Name="TitleText" FontSize="15" FontWeight="Bold" Foreground="#E2E8F0" FontFamily="Segoe UI"/>
            </StackPanel>
            <TextBlock Name="MessageText" FontSize="13" Foreground="#94A3B8" Margin="0,8,0,0" TextWrapping="Wrap" FontFamily="Segoe UI"/>
            <TextBlock Text="点击任意位置关闭" FontSize="11" Foreground="#475569" Margin="0,12,0,0" HorizontalAlignment="Right" FontStyle="Italic"/>
        </StackPanel>
    </Border>
</Window>
'@

$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($xaml))
$window = [System.Windows.Markup.XamlReader]::Load($reader)

$window.FindName("TitleText").Text = $Title
$window.FindName("MessageText").Text = $Message

# Click anywhere to close
$window.Add_MouseLeftButtonDown({ $window.Close() })

# Fade in
$fadeIn = New-Object System.Windows.Media.Animation.DoubleAnimation 0,1,([TimeSpan]::FromMilliseconds(400))
$window.BeginAnimation([System.Windows.Window]::OpacityProperty, $fadeIn)

# Auto close
$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(10)
$timer.add_Tick({
    $window.Close()
})
$timer.Start()

$window.ShowDialog() | Out-Null
exit 0
