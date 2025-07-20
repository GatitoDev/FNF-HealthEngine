package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class OptionsScreen extends MusicBeatState
{
    final PANEL_WIDTH:Int = 600;
    final PANEL_HEIGHT:Int = 400;
    final PADDING:Int = 20;
    final HEADER_HEIGHT:Int = 30;
    final BUTTON_HEIGHT:Int = 30;
    
    var panelGroup:FlxSpriteGroup;
    var buttons:Array<FlxSprite>;
    var buttonLabels:Array<FlxText>;
    var currentSelected:Int = 0;
    
    override function create() {
        super.create();
        FlxG.mouse.visible = true;
        var bg:FlxSprite = Sprite.createBG('menuDesat', {scale: 1.1, color: FlxColor.GRAY});
        add(bg.screenCenter());
        initPanel();
    }
    
    function initPanel():Void
    {
        panelGroup = new FlxSpriteGroup();
        final panelX:Dynamic = (FlxG.width - PANEL_WIDTH) / 2;
        final panelY:Dynamic = (FlxG.height - PANEL_HEIGHT) / 2;
        
        // Create panel background
        panelGroup.add(createPanelBG(panelX, panelY));
        panelGroup.add(createHeaderBG(panelX, panelY));
        panelGroup.add(createHeaderText(panelX, panelY));
        
        // Create navigation buttons
        createNavigationButtons(panelX, panelY + HEADER_HEIGHT);
        
        add(panelGroup);
    }
    
    function createPanelBG(x:Float, y:Float):FlxSprite {
        var bg:FlxSprite = new FlxSprite(x, y).makeGraphic(PANEL_WIDTH, PANEL_HEIGHT, FlxColor.BLACK);
        bg.alpha = 0.7;
        return bg;
    }
    
    function createHeaderBG(x:Float, y:Float):FlxSprite {
        var header:FlxSprite = new FlxSprite(x, y).makeGraphic(PANEL_WIDTH, HEADER_HEIGHT, FlxColor.fromRGB(40, 40, 40));
        header.alpha = 0.9;
        return header;
    }
    
    function createHeaderText(x:Float, y:Float):FlxText {
        var text:FlxText = new FlxText(x + PADDING, y + (HEADER_HEIGHT - 20) / 2, PANEL_WIDTH - (PADDING * 2), "OPTIONS", 24);
        text.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, CENTER);
        return text;
    }
    
    function createNavigationButtons(x:Float, y:Float):Void {
        buttons = [];
        buttonLabels = [];
        
        var buttonTitles:Array<String> = ["Gameplay", "Appearance", "Misc", "Audio"];
        var buttonWidth:Int = Std.int(PANEL_WIDTH / buttonTitles.length); // Dividir el ancho total entre la cantidad de botones
        
        for (i in 0...buttonTitles.length) {
            var buttonX:Float = x + buttonWidth * i; // Eliminar el padding entre botones
            var button:FlxSprite = new FlxSprite(buttonX, y).makeGraphic(buttonWidth, BUTTON_HEIGHT, FlxColor.fromRGB(60, 60, 60));
            button.alpha = 0.8;
            
            // Add hover effect
            button.setGraphicSize(buttonWidth, BUTTON_HEIGHT);
            button.updateHitbox();
            
            // Add button label
            var label:FlxText = new FlxText(buttonX, y + (BUTTON_HEIGHT - 20) / 2, buttonWidth, buttonTitles[i], 20);
            label.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, CENTER);
            
            // Store references
            buttons.push(button);
            buttonLabels.push(label);
            
            panelGroup.add(button);
            panelGroup.add(label);
        }
        
        // Set initial selection
        updateButtonSelection(0);
    }
    
    function updateButtonSelection(newSelection:Int):Void {
        // Reset all buttons to default color
        for (button in buttons) {
            button.color = FlxColor.fromRGB(60, 60, 60);
        }
        
        // Highlight selected button
        if (newSelection >= 0 && newSelection < buttons.length) {
            buttons[newSelection].color = FlxColor.WHITE;
            currentSelected = newSelection;
        }
    }
    
    override function update(elapsed:Float):Void {
        super.update(elapsed);
        
        // Handle mouse hover and clicks
        for (i in 0...buttons.length) {
            if (FlxG.mouse.overlaps(buttons[i])) {
                updateButtonSelection(i);
                
                if (FlxG.mouse.justPressed) {
                    // Handle button click here
                    trace('Button clicked: ${buttonLabels[i].text}');
                }
            }
        }
    }
}