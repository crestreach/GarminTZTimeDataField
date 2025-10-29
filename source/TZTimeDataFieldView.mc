import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Application.Properties;

class TZTimeDataFieldView extends WatchUi.SimpleDataField {


    var tzOffset as Number = 0;
    var displaySecs as Boolean = true;
    var lastPropsReloadTime as Time.Moment = Time.now();
    var tzInLabel as Boolean = true;
    var initialized as Boolean = false;

    function initialize() {
        SimpleDataField.initialize();
        loadProps();

        if (tzInLabel) {
            var offsetSign = (tzOffset >= 0) ? "+" : "";
            var offsetText = "UTC" + offsetSign + tzOffset;
            label = offsetText;
        } else {
            label = WatchUi.loadResource(Rez.Strings.label) as String;
        }

        initialized = true;
    }

    function compute(info) {
        if (!initialized || lastPropsReloadTime.add(new Time.Duration(10)).compare(Time.now()) < 0) {
            // refresh properties every 10 seconds
            loadProps();
        }

        // var offsetSign = (tzOffset >= 0) ? "+" : "";
        // var offsetText = "UTC" + offsetSign + tzOffset;
        // label = offsetText;     //setting the label after initialization won't work, but might be added in future

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
        var tzOffsetValue = Properties.getValue("tzOffset");
        if (tzOffsetValue != null && tzOffsetValue instanceof Number) {
            tzOffset = tzOffsetValue as Number;
        } else {
            tzOffset = 0;
        }

        var displaySecsValue = Properties.getValue("displaySecs");
        if (displaySecsValue != null && displaySecsValue instanceof Boolean) {
            displaySecs = displaySecsValue as Boolean;
        } else {
            displaySecs = true;
        }
        
        var tzInLabelValue = Properties.getValue("tzInLabel");
        if (tzInLabelValue != null && tzInLabelValue instanceof Boolean) {
            tzInLabel = tzInLabelValue as Boolean;
        } else {
            tzInLabel = true;
        }


        lastPropsReloadTime = Time.now();
    }

}