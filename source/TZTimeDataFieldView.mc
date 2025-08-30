import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Application.Properties;

class TZTimeDataFieldView extends WatchUi.DataField {

    var tzOffset as Number = 0;
    var displaySecs as Boolean = true;
    var lastPropsReloadTime;
    var yOffsetLabel = 0;
    var yOffsetValue = 0;

    function initialize() {
        DataField.initialize();
        loadProps();
    }

    function onUpdate(dc as Dc) as Void {

        if (lastPropsReloadTime.add(new Time.Duration(10)).compare(Time.now()) < 0) {
            // refresh properties every 10 seconds
            loadProps();
        }

		var offsetSign = (tzOffset >= 0) ? "+" : "";
		var offsetText = "UTC" + offsetSign + tzOffset;        

        var offsetSecs = tzOffset * 3600;
        var moment = Time.now();
        var duration = new Time.Duration(offsetSecs);
        var newMoment = moment.add(duration);
        var utcInfo = Gregorian.utcInfo(newMoment, Time.FORMAT_SHORT);

		// Format the time
		var hours = utcInfo.hour.format("%02d");
		var mins  = utcInfo.min.format("%02d");
		var timeText = hours + ":" + mins;
        if (displaySecs) {
            var secs  = utcInfo.sec.format("%02d");
            timeText = timeText + ":" + secs;
        }

        // System.println(offsetText + ", " + timeText);

        var fgColor;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            fgColor = Graphics.COLOR_WHITE;
        } else {
            fgColor = Graphics.COLOR_BLACK;
        }
        
        dc.setColor(getBackgroundColor(), getBackgroundColor());
        dc.clear();
        dc.setColor(fgColor, Graphics.COLOR_TRANSPARENT);

        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 24 + yOffsetLabel, Graphics.FONT_XTINY, offsetText, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 9 + yOffsetValue, Graphics.FONT_MEDIUM, timeText, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function loadProps() as Void {
        tzOffset = Properties.getValue("tzOffset");
        displaySecs = Properties.getValue("displaySecs");
        yOffsetLabel = Properties.getValue("yOffsetLabel");
        yOffsetValue = Properties.getValue("yOffsetValue");

        lastPropsReloadTime = Time.now();
    }

}
