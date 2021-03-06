package com.squad.dr.tools;
import com.squad.dr.widgets.Button;
import com.squad.dr.widgets.Widget;
import com.squad.dr.PubNub;
import org.flixel.FlxGroup;

class Syringe extends Tool
{
  private var _drugButtonsGroup: FlxGroup;
  private var _drugButtons: Array<Button>;
  private var _drugNames: Array<String>;
  private var _showDrugs: Bool;

  public override function initialise(attributes:Dynamic)
  {
    attributes.image_info = Widget.IMAGEINFO_SYRINGE;
    attributes.tool_name = "Syringe";
    super.initialise(attributes);
    _drugNames = attributes.drugs;
    _drugButtons = new Array<Button>();
    var index = 0;
    _drugButtonsGroup = new FlxGroup();
    for (drugname in _drugNames)
    {
      //DrSquad.log("attrs:X=" + attributes.x + " attrs.Y=" + attributes.y);
      var b = new Button(_toolbutton.x-_toolbutton.width, _toolbutton.y-index*(64), drugname,
        function(){onDrugButtonClick(drugname);});
      trace("attributes.x = " + attributes.x);
      trace("syringe.x = " + x);
      b.setImageInfo(Widget.IMAGEINFO_LONGBUTTON);
      b.scale.x = b.scale.y = 0.25;
      b.setLabelSane();
  
      _drugButtons.push(b);
      _drugButtonsGroup.add(b);
      index ++;
    }
    _showDrugs = true;
    add(_drugButtonsGroup);
    toggleShowDrugs();
  }

  private function toggleShowDrugs()
  {
    _showDrugs = !_showDrugs;
    if (_showDrugs)
    {
      add(_drugButtonsGroup);
    }
    else
    {
      remove(_drugButtonsGroup);
    }
  }

  public function onDrugButtonClick(drugname:String): Void
  {
    if (is_owner()) {
      DrSquad.log("drug button clicked: " + drugname);
      PubNub.room.send({type: "tool", action: "syringe", widgetId: _widgetId, data: drugname});
      toggleShowDrugs();
    }
  }

  public override function onToolClick(): Void
  {
    DrSquad.log("onToolClick fired");
    if (is_owner()) {
      DrSquad.log("Clicked the syringe");
      toggleShowDrugs();
    }
  }
}
