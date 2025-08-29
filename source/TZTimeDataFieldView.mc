import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Application.Properties;

class TZTimeDataFieldView extends WatchUi.DataField {

    var tzOffset as Number = 0;
    var displaySecs as Boolean = true;

    function initialize() {
        DataField.initialize();

        tzOffset = Properties.getValue("tzOffset");
        System.println("tzOffset: " + tzOffset);
        
        displaySecs = Properties.getValue("displaySecs");
        System.println("displaySecs: " + displaySecs);
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void {
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("label") as Text;
            labelView.locY = labelView.locY - 15;
            var valueView = View.findDrawableById("value") as Text;
            valueView.locY = valueView.locY + 11;
        }

		var offsetSign = (tzOffset >= 0) ? "+" : "";
		var offsetText = "UTC" + offsetSign + tzOffset;

        System.println(offsetText);

        var label = View.findDrawableById("label") as Text;

        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            label.setColor(Graphics.COLOR_WHITE);
        } else {
            label.setColor(Graphics.COLOR_BLACK);
        }
        
        label.setText(offsetText);

    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {

    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        // Set the background color
        (View.findDrawableById("Background") as Text).setColor(getBackgroundColor());

        // Set the foreground color and value
        var value = View.findDrawableById("value") as Text;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            value.setColor(Graphics.COLOR_WHITE);
        } else {
            value.setColor(Graphics.COLOR_BLACK);
        }


		var offsetSecs = tzOffset * 3600;

        var moment = Time.now();
        var duration = new Time.Duration(offsetSecs);
        var newMoment = moment.add(duration);
        
        var utcInfo = Gregorian.utcInfo(newMoment, Time.FORMAT_SHORT);
		// var tzInfo = Gregorian.info(moment, Time.FORMAT_SHORT);

		// Format the time
		var hours = utcInfo.hour.format("%02d");
		var mins  = utcInfo.min.format("%02d");
		var timeText = hours + ":" + mins;

        if (displaySecs) {
            var secs  = utcInfo.sec.format("%02d");
            timeText = timeText + ":" + secs;
        }

        System.println(timeText);

        value.setText(timeText);


        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);

    }

}
