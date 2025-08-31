import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Application.Properties;

class TZTimeDataFieldView extends WatchUi.SimpleDataField {

    var tzOffset as Number = 0;
    var displaySecs as Boolean = true;
    var lastPropsReloadTime;
    var tzInLabel = true;

    function initialize() {
        SimpleDataField.initialize();
        loadProps();

        if (tzInLabel) {
            var offsetSign = (tzOffset >= 0) ? "+" : "";
            var offsetText = "UTC" + offsetSign + tzOffset;
            label = offsetText;
        } else {
            label = loadResource(Rez.Strings.label);
        }
    }

    function compute(info) {
        if (lastPropsReloadTime.add(new Time.Duration(10)).compare(Time.now()) < 0) {
            // refresh properties every 10 seconds
            loadProps();
        }

        var offsetSign = (tzOffset >= 0) ? "+" : "";
		var offsetText = "UTC" + offsetSign + tzOffset;
        label = offsetText;     //setting the label after initialization won't work, but might be added in future

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

        return " " + timeText + " ";
    }

    private function loadProps() as Void {
        tzOffset = Properties.getValue("tzOffset");
        displaySecs = Properties.getValue("displaySecs");
        tzInLabel = Properties.getValue("tzInLabel");

        lastPropsReloadTime = Time.now();
    }

}