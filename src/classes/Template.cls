/**
 * MIT License
 *
 * Copyright (c) 2018 Click to Cloud Pty Ltd
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 **/
/**
 * Used to evaluate templates with syntax similar to visualforce page
 * */
public class Template {
    // Options
    private Options opts = null;

    // ScriptEngine for VF syntax
    private ScriptEngine engine = null;

    // Template functions
    private Functions funcs = null;

    /**
     * Create a template instance from the options
     *
     * @param opts The template options
     * */
    public Template(Options opts) {
        if(opts == null) {
            opts = new Options();
        }

        this.opts = opts;
        this.engine = new ScriptEngine();
        this.funcs = new Functions();
    }

    /**
     * Create a default template instance
     * */
    public Template() {
        this(null);
    }

    /**
     * Evaluate the string using the context
     *
     * Example:
     * Template t = new Template();
     * String output = t.evaluate('{! name }', new Map<String, Object>{ 'name' => 'wilson' });
     *
     * @param input The input string
     * @param context The variable context
     * @return String
     * */
    public String evaluate(String input, Map<String, Object> context) {
        if(String.isBlank(input)) {
            return input;
        }

        List<String> pieces = new List<String>();

        Map<String, Object> allContext = new Map<String, Object>();

        if(context != null) {
            for(String name : context.keySet()) {
                Object value = context.get(name);
                allContext.put(name.toUpperCase(), value);
            }
        }

        allContext.putAll(this.funcs.functions);

        if(this.opts.functions != null) {
            for(String name : this.opts.functions.keySet()) {
                Func f = this.opts.functions.get(name);
                addFunc(allContext, name, f);
            }
        }

        Integer curr = 0;
        Integer nextStart = null;
        Integer nextEnd = null;

        while(true) {
            nextStart = input.indexOf(this.opts.expressionStart, curr);
            if(nextStart < 0) {
                pieces.add(input.substring(curr, input.length()));
                break;
            }
            nextEnd = input.indexOf(this.opts.expressionEnd, nextStart);
            pieces.add(input.substring(curr, nextStart));
            String expression = input.substring(nextStart + 2, nextEnd);

            try {
                Object value = this.engine.eval(expression, allContext);
                pieces.add(toString(value));
            }
            catch(Exception e) {
                if(this.opts.suppressErrors) {
                    pieces.add('');
                }
                else {
                    throw e;
                }
            }

            curr = nextEnd + 1;
        }

        return String.join(pieces, '');
    }

    private String toString(Object obj) {
        if(obj == null) {
            return '';
        }
        else if(obj instanceof Date) {
            return '' + (Date)obj;
        }
        else if(obj instanceof Time) {
            return '' + (Time)obj;
        }
        else if(obj instanceof Datetime) {
            return '' + (Datetime)obj;
        }
        else {
            return String.valueOf(obj);
        }
    }

    private static final Map<String, Jsep.Node> cache = new Map<String, Jsep.Node>();

    private static String stringOf(Object value) {
        return value == null ? 'null' : String.valueOf(value);
    }

    private static Boolean isInteger(String val) {
        try {
            Integer.valueOf(val);
            return true;
        }
        catch(Exception e) {
            return false;
        }
    }

    private static void addFunc(Map<String, Object> funcs, String name, Func f) {
        if(funcs != null && !String.isBlank(name) && f != null) {
            funcs.put(name.toUpperCase(), f);
        }
    }

    /**
     * Options for Template
     * */
    public class Options {
        /**
         * The start of the expression
         * */
        public String expressionStart = '{!';

        /**
         * The end of the expression
         * */
        public String expressionEnd = '}';

        /**
         * Whether to suppress errors
         * When suppressing errors, expression that will produce errors will result in empty strings
         * */
        public Boolean suppressErrors = true;

        /**
         * Extra functions for the template
         * */
        public Map<String, Func> functions = new Map<String, Func>();
    }

    public class TemplateException extends Exception {
    }

    private static final Func addMonthsF = new AddMonthsFunc();
    private static final Func dateF = new DateFunc();
    private static final Func dateValueF = new DateValueFunc();
    private static final Func datetimeValueF = new DatetimeValueFunc();
    private static final Func dayF = new DayFunc();
    private static final Func monthF = new MonthFunc();
    private static final Func nowF = new NowFunc();
    private static final Func todayF = new TodayFunc();
    private static final Func weekdayF = new WeekdayFunc();
    private static final Func yearF = new YearFunc();

    private static final Func blankValueF = new BlankValueFunc();
    private static final Func caseF = new CaseFunc();
    private static final Func ifF = new IfFunc();
    private static final Func isBlankF = new IsBlankFunc();
    private static final Func nullValueF = new NullValueFunc();

    private static final Func absF = new AbsFunc();
    private static final Func ceilingF = new CeilingFunc();
    private static final Func expF = new ExpFunc();
    private static final Func floorF = new FloorFunc();
    private static final Func lnF = new LnFunc();
    private static final Func logF = new LogFunc();
    private static final Func maxF = new MaxFunc();
    private static final Func minF = new MinFunc();
    private static final Func mceilingF = new MCeilingFunc();
    private static final Func mfloorF = new MFloorFunc();
    private static final Func roundF = new RoundFunc();
    private static final Func sqrtF = new SqrtFunc();

    private static final Func findF = new FindFunc();
    private static final Func getSessionIdF = new GetSessionIdFunc();
    private static final Func htmlEncodeF = new HTMLEncodeFunc();
    private static final Func jsEncodeF = new JsEncodeFunc();
    private static final Func lowerF = new LowerFunc();
    private static final Func upperF = new UpperFunc();
    private static final Func lPadF = new LPadFunc();
    private static final Func rPadF = new RPadFunc();
    private static final Func midF = new MidFunc();
    private static final Func urlEncodeF = new URLEncodeFunc();

    private class Functions {
        public Map<String, Func> functions = new Map<String, Func>();

        public Functions() {
            addFunc(this.functions, 'ADDMONTHS', addMonthsF);
            addFunc(this.functions, 'DATE', dateF);
            addFunc(this.functions, 'DATEVALUE', dateValueF);
            addFunc(this.functions, 'DATETIMEVALUE', datetimeValueF);
            addFunc(this.functions, 'DAY', dayF);
            addFunc(this.functions, 'MONTH', monthF);
            addFunc(this.functions, 'NOW', nowF);
            addFunc(this.functions, 'TODAY', todayF);
            addFunc(this.functions, 'WEEKDAY', weekdayF);
            addFunc(this.functions, 'YEAR', yearF);

            addFunc(this.functions, 'AND', R.doAnd);
            addFunc(this.functions, 'BLANKVALUE', blankValueF);
            addFunc(this.functions, 'CASE', caseF);
            addFunc(this.functions, 'IF', ifF);
            addFunc(this.functions, 'ISBLANK', isBlankF);
            addFunc(this.functions, 'ISNULL', R.isNull);
            addFunc(this.functions, 'ISNUMBER', R.isNumber);
            addFunc(this.functions, 'NOT', R.doNot);
            addFunc(this.functions, 'NULLVALUE', nullValueF);
            addFunc(this.functions, 'OR', R.doOr);

            addFunc(this.functions, 'ABS', absF);
            addFunc(this.functions, 'CEILING', ceilingF);
            addFunc(this.functions, 'EXP', expF);
            addFunc(this.functions, 'FLOOR', floorF);
            addFunc(this.functions, 'LN', lnF);
            addFunc(this.functions, 'LOG', logF);
            addFunc(this.functions, 'MAX', maxF);
            addFunc(this.functions, 'MIN', minF);
            addFunc(this.functions, 'MCEILING', mceilingF);
            addFunc(this.functions, 'MFLOOR', mfloorF);
            addFunc(this.functions, 'MOD', R.mod);
            addFunc(this.functions, 'ROUND', roundF);
            addFunc(this.functions, 'SQRT', sqrtF);

            addFunc(this.functions, 'BEGINS', (Func)R.flip.run(R.startsWith));
            addFunc(this.functions, 'BR', R.constant.apply('<br>'));
            addFunc(this.functions, 'CONTAINS', (Func)R.flip.run(R.contains));
            addFunc(this.functions, 'FIND', findF);
            addFunc(this.functions, 'GETSESSIONID', getSessionIdF);
            addFunc(this.functions, 'HTMLENCODE', htmlEncodeF);
            addFunc(this.functions, 'JSENCODE', jsEncodeF);
            addFunc(this.functions, 'JSINHTMLENCODE', (Func)R.pipe.run(htmlEncodeF, jsEncodeF));
            addFunc(this.functions, 'LEFT', (Func)R.flip.run(R.take));
            addFunc(this.functions, 'RIGHT', (Func)R.flip.run(R.takeRight));
            addFunc(this.functions, 'LEN', R.length);
            addFunc(this.functions, 'LOWER', lowerF);
            addFunc(this.functions, 'UPPER', upperF);
            addFunc(this.functions, 'LPAD', lPadF);
            addFunc(this.functions, 'RPAD', rPadF);
            addFunc(this.functions, 'MID', midF);
            addFunc(this.functions, 'SUBSTITUTE', R.replace);
            addFunc(this.functions, 'TEXT', R.toString);
            addFunc(this.functions, 'TRIM', R.trim);
            addFunc(this.functions, 'URLENCODE', urlEncodeF);
            addFunc(this.functions, 'VALUE', R.toInteger);

            addFunc(this.functions, 'REGEX', (Func)R.flip.run(R.test));
        }
    }

    private class URLEncodeFunc extends Func {
        public URLEncodeFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            String input = (String)R.toString.run(arg);

            return EncodingUtil.urlEncode(input, 'UTF-8');
        }
    }

    private class MidFunc extends Func {
        public MidFunc() {
            super(3);
        }

        public override Object exec(Object arg1, Object arg2, Object arg3) {
            String input = (String)R.toString.run(arg1);
            Integer startIndex = (Integer)R.toInteger.run(arg2);
            Integer num = (Integer)R.toInteger.run(arg3);

            return input.mid(startIndex, num);
        }
    }

    private class RPadFunc extends Func {
        public RPadFunc() {
            super(-1);
        }

        public override Object exec(Object arg1, Object arg2) {
            String input = (String)R.toString.run(arg1);
            Integer length = (Integer)R.toInteger.run(arg2);

            return input.rightPad(length);
        }

        public override Object exec(Object arg1, Object arg2, Object arg3) {
            String input = (String)R.toString.run(arg1);
            Integer length = (Integer)R.toInteger.run(arg2);
            String padStr = (String)R.toString.run(arg3);

            return input.rightPad(length, padStr);
        }
    }

    private class LPadFunc extends Func {
        public LPadFunc() {
            super(-1);
        }

        public override Object exec(Object arg1, Object arg2) {
            String input = (String)R.toString.run(arg1);
            Integer length = (Integer)R.toInteger.run(arg2);

            return input.leftPad(length);
        }

        public override Object exec(Object arg1, Object arg2, Object arg3) {
            String input = (String)R.toString.run(arg1);
            Integer length = (Integer)R.toInteger.run(arg2);
            String padStr = (String)R.toString.run(arg3);

            return input.leftPad(length, padStr);
        }
    }

    private class UpperFunc extends Func {
        public UpperFunc() {
            super(-1);
        }

        public override Object exec(Object arg1) {
            String input = (String)R.toString.run(arg1);

            return input.toUpperCase();
        }

        public override Object exec(Object arg1, Object arg2) {
            String input = (String)R.toString.run(arg1);
            String locale = (String)R.toString.run(arg2);

            return input.toUpperCase(locale);
        }
    }

    private class LowerFunc extends Func {
        public LowerFunc() {
            super(-1);
        }

        public override Object exec(Object arg1) {
            String input = (String)R.toString.run(arg1);

            return input.toLowerCase();
        }

        public override Object exec(Object arg1, Object arg2) {
            String input = (String)R.toString.run(arg1);
            String locale = (String)R.toString.run(arg2);

            return input.toLowerCase(locale);
        }
    }

    private class JsEncodeFunc extends Func {
        public JsEncodeFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            String js = (String)R.toString.run(arg);

            return js.escapeEcmaScript();
        }
    }

    private class HTMLEncodeFunc extends Func {
        public HTMLEncodeFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            String html = (String)R.toString.run(arg);

            return html.escapeHtml4();
        }
    }

    private class GetSessionIdFunc extends Func {
        public GetSessionIdFunc() {
            super(0);
        }

        public override Object exec() {
            return UserInfo.getSessionId();
        }
    }

    private class FindFunc extends Func {
        public FindFunc() {
            super(-1);
        }

        public override Object exec(Object arg1, Object arg2) {
            String s1 = (String)R.toString.run(arg1);
            String s2 = (String)R.toString.run(arg2);

            return s1.indexOf(s2);
        }

        public override Object exec(Object arg1, Object arg2, Object arg3) {
            String s1 = (String)R.toString.run(arg1);
            String s2 = (String)R.toString.run(arg2);
            Integer pos = (Integer)R.toInteger.run(arg3);

            return s1.indexOf(s2, pos);
        }
    }

    private class SqrtFunc extends Func {
        public SqrtFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            if(arg instanceof Double) {
                return Math.sqrt((Double)arg);
            }
            else if(arg instanceof Decimal) {
                return Math.sqrt((Decimal)arg);
            }
            else {
                return null;
            }
        }
    }

    private class RoundFunc extends Func {
        public RoundFunc() {
            super(2);
        }

        public override Object exec(Object arg1, Object arg2) {
            Integer num = (Integer)R.toInteger.run(arg2);
            Double offset = Math.pow(10, num - 1);
            if(arg1 instanceof Double) {
                Double d = (Double)arg1;
                Long val = Math.roundToLong(d * offset);
                return val / offset;
            }
            else if(arg1 instanceof Decimal) {
                Decimal d = (Decimal)arg1;
                Long val = Math.roundToLong(d * offset);
                return val / offset;
            }
            else {
                return arg1;
            }
        }
    }

    private class MCeilingFunc extends Func {
        public MCeilingFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            if(arg instanceof Double) {
                return Math.ceil((Double)arg);
            }
            else if(arg instanceof Decimal) {
                return Math.ceil((Decimal)arg);
            }
            else {
                return null;
            }
        }
    }

    private class MFloorFunc extends Func {
        public MFloorFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            if(arg instanceof Double) {
                return Math.floor((Double)arg);
            }
            else if(arg instanceof Decimal) {
                return Math.floor((Decimal)arg);
            }
            else {
                return null;
            }
        }
    }

    private class MinFunc extends Func {
        public MinFunc() {
            super(-1);
        }

        public override Object execN(List<Object> args) {
            if(!args.isEmpty()) {
                Object min = args.get(0);

                for(Integer i = 1; i < args.size(); i++) {
                    min = R.min.run(min, args.get(i));
                }

                return min;
            }

            return null;
        }
    }

    private class MaxFunc extends Func {
        public MaxFunc() {
            super(-1);
        }

        public override Object execN(List<Object> args) {
            if(!args.isEmpty()) {
                Object max = args.get(0);

                for(Integer i = 1; i < args.size(); i++) {
                    max = R.max.run(max, args.get(i));
                }

                return max;
            }

            return null;
        }
    }

    private class LogFunc extends Func {
        public LogFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            if(arg instanceof Double) {
                return Math.log10((Double)arg);
            }
            else if(arg instanceof Decimal) {
                return Math.log10((Decimal)arg);
            }
            else {
                return arg;
            }
        }
    }

    private class LnFunc extends Func {
        public LnFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            if(arg instanceof Double) {
                return Math.log((Double)arg);
            }
            else if(arg instanceof Decimal) {
                return Math.log((Decimal)arg);
            }
            else {
                return arg;
            }
        }
    }

    private class FloorFunc extends Func {
        public FloorFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            if(arg instanceof Double) {
                Double d = (Double)arg;
                return d < 0 ? -Math.floor(Math.abs(d)) : Math.floor(Math.abs(d));
            }
            else if(arg instanceof Decimal) {
                Decimal d = (Decimal)arg;
                return d < 0 ? -Math.floor(Math.abs(d)) : Math.floor(Math.abs(d));
            }
            else {
                return arg;
            }
        }
    }

    private class ExpFunc extends Func {
        public ExpFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            if(arg instanceof Double) {
                return Math.exp((Double)arg);
            }
            else if(arg instanceof Decimal) {
                return Math.exp((Decimal)arg);
            }
            else {
                return arg;
            }
        }
    }

    private class CeilingFunc extends Func {
        public CeilingFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            if(arg instanceof Double) {
                Double d = (Double)arg;
                return d < 0 ? -Math.ceil(Math.abs(d)) : Math.ceil(Math.abs(d));
            }
            else if(arg instanceof Decimal) {
                Decimal d = (Decimal)arg;
                return d < 0 ? -Math.ceil(Math.abs(d)) : Math.ceil(Math.abs(d));
            }
            else {
                return arg;
            }
        }
    }

    private class AbsFunc extends Func {
        public AbsFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            if(arg instanceof Integer) {
                return Math.abs((Integer)arg);
            }
            else if(arg instanceof Long) {
                return Math.abs((Long)arg);
            }
            else if(arg instanceof Double) {
                return Math.abs((Double)arg);
            }
            else if(arg instanceof Decimal) {
                return Math.abs((Decimal)arg);
            }
            else {
                return arg;
            }
        }
    }

    private class NullValueFunc extends Func {
        public NullValueFunc() {
            super(2);
        }

        public override Object exec(Object arg1, Object arg2) {
            return ((Boolean)R.isNull.run(arg1)) ? arg2 : arg1;
        }
    }

    private class IsBlankFunc extends Func {
        public IsBlankFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            if(arg == null) {
                return true;
            }
            else if(arg instanceof String && String.isBlank((String)arg)) {
                return true;
            }
            else {
                return false;
            }
        }
    }

    private class IfFunc extends Func {
        public IfFunc() {
            super(3);
        }

        public override Object exec(Object arg1, Object arg2, Object arg3) {
            Boolean pass = (Boolean)R.toBoolean.run(arg1);
            return pass ? arg2 : arg3;
        }
    }

    private class CaseFunc extends Func {
        public CaseFunc() {
            super(-1);
        }

        public override Object execN(List<Object> args) {
            if(!args.isEmpty()) {
                Object target = args.get(0);
                for(Integer i = 1; i < args.size() - 1; i++) {
                    Object val = args.get(i);
                    if(val == target) {
                        return args.get(i + 1);
                    }
                }
            }

            return null;
        }
    }

    private class BlankValueFunc extends Func {
        public BlankValueFunc() {
            super(2);
        }

        public override Object exec(Object arg1, Object arg2) {
            return (Boolean)isBlankF.run(arg1) ? arg2 : arg1;
        }
    }

    private class YearFunc extends Func {
        public YearFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            Date d = (Date)R.toDate.run(arg);
            return d.year();
        }
    }

    private class WeekdayFunc extends Func {
        public WeekdayFunc() {
            super(1);
        }

        private Integer getDayNumberInWeek(Integer year, Integer month, Integer day) {
            if(month == 1 || month == 2) {
                month += 12;
                year -= 1;
            }

            Integer num = Math.mod((day + 1 + 2 * month + 3 * (month + 1) / 5 + year + year / 4 - year / 100 + year / 400), 7);
            return num == 0 ? 1 : num + 1; // 2 for Mon, 1 for Sun, 7 for Sat
        }

        public override Object exec(Object arg) {
            Date d = (Date)R.toDate.run(arg);

            return getDayNumberInWeek(d.year(), d.month(), d.day());
        }
    }

    private class TodayFunc extends Func {
        public TodayFunc() {
            super(0);
        }

        public override Object exec() {
            return Date.today();
        }
    }

    private class NowFunc extends Func {
        public NowFunc() {
            super(0);
        }

        public override Object exec() {
            return Datetime.now();
        }
    }

    private class MonthFunc extends Func {
        public MonthFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            Date d = (Date)R.toDate.run(arg);
            return d.month();
        }
    }

    private class DayFunc extends Func {
        public DayFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            Date d = (Date)R.toDate.run(arg);
            return d.day();
        }
    }

    private class DatetimeValueFunc extends Func {
        public DatetimeValueFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            if(arg instanceof String) {
                return Datetime.valueOfGmt((String)arg);
            }
            else if(arg instanceof Datetime) {
                return arg;
            }
            else {
                return null;
            }
        }
    }

    private class DateValueFunc extends Func {
        public DateValueFunc() {
            super(1);
        }

        public override Object exec(Object arg) {
            if(arg instanceof String) {
                return Date.parse((String)arg);
            }
            else if(arg instanceof Datetime) {
                return ((Datetime)arg).date();
            }
            else {
                return null;
            }
        }
    }

    private class DateFunc extends Func {
        public DateFunc() {
            super(3);
        }

        public override Object exec(Object arg1, Object arg2, Object arg3) {
            Integer year = (Integer)R.toInteger.run(arg1);
            Integer month = (Integer)R.toInteger.run(arg2);
            Integer day = (Integer)R.toInteger.run(arg3);

            return Date.newInstance(year, month, day);
        }
    }

    private class AddMonthsFunc extends Func {
        public AddMonthsFunc() {
            super(2);
        }

        public override Object exec(Object arg1, Object arg2) {
            Date d = (Date)R.toDate.run(arg1);
            Integer num = (Integer)R.toInteger.run(arg2);

            return d.addMonths(num);
        }
    }

    private class ScriptEngine {
        public ScriptEngine() {
            Jsep.addBinaryOp('<>', 7);
            Jsep.addBinaryOp('^', 12);
        }

        private Object evalIdentifier(String name, Map<String, Object> context) {
            return context.get(name.toUpperCase());
        }

        private Object evalMember(Object target, String property, Map<String, Object> context) {
            if(target instanceof List<Object> && isInteger(property)) {
                return ((List<Object>)target).get(Integer.valueOf(property));
            }
            else if(target instanceof Map<String, Object>) {
                return ((Map<String, Object>)target).get(property);
            }
            else if(target instanceof String && isInteger(property)) {
                return ((String)target).split('').get(Integer.valueOf(property));
            }
            else if(target instanceof SObject) {
                return ((SObject)target).get(property);
            }

            throw new TemplateException('Cannot evaluate "' + property + '" of "' + String.valueOf(target) + '"');
        }

        private Object evalCall(Object callee, List<Object> arguments, Map<String, Object> context) {
            if(callee instanceof Func) {
                return ((Func)callee).runN(arguments);
            }

            throw new TemplateException('Cannot call function: ' + stringOf(callee));
        }

        public Object eval(String code, Map<String, Object> context) {
            Jsep.Node node = cache.get(code);
            if(node == null) {
                node = new Jsep(code).parse();
                cache.put(code, node);
            }

            return this.eval(node, context);
        }

        public Object eval(Jsep.Node node, Map<String, Object> context) {
            if(context == null) {
                context = new Map<String, Object>();
            }

            if(node instanceof Jsep.IdentifierNode) {
                return eval((Jsep.IdentifierNode)node, context);
            }
            else if(node instanceof Jsep.MemberExpressionNode) {
                return eval((Jsep.MemberExpressionNode)node, context);
            }
            else if(node instanceof Jsep.LiteralNode) {
                return eval((Jsep.LiteralNode)node, context);
            }
            else if(node instanceof Jsep.CallExpressionNode) {
                return eval((Jsep.CallExpressionNode)node, context);
            }
            else if(node instanceof Jsep.UnaryExpressionNode) {
                return eval((Jsep.UnaryExpressionNode)node, context);
            }
            else if(node instanceof Jsep.BinaryExpressionNode) {
                return eval((Jsep.BinaryExpressionNode)node, context);
            }
            else if(node instanceof Jsep.LogicalExpressionNode) {
                return eval((Jsep.LogicalExpressionNode)node, context);
            }
            else if(node instanceof Jsep.AssignmentExpressionNode) {
                return eval((Jsep.AssignmentExpressionNode)node, context);
            }
            else if(node instanceof Jsep.ConditionalExpressionNode) {
                return eval((Jsep.ConditionalExpressionNode)node, context);
            }

            throw new TemplateException('Invalid expression to evaluate: ' + stringOf(node));
        }

        private Object eval(Jsep.IdentifierNode node, Map<String, Object> context) {
            return this.evalIdentifier(node.name, context);
        }

        private Object eval(Jsep.MemberExpressionNode node, Map<String, Object> context) {
            Object target = this.eval(node.target, context);
            String property = null;
            if(node.computed) {
                property = String.valueOf(this.eval(node.property, context));
            }
            else {
                property = ((Jsep.IdentifierNode)node.property).name;
            }
            return this.evalMember(target, property, context);
        }

        private Object eval(Jsep.LiteralNode node, Map<String, Object> context) {
            return node.value;
        }

        private Object eval(Jsep.CallExpressionNode node, Map<String, Object> context) {
            Object callee = this.eval(node.callee, context);
            List<Object> arguments = new List<Object>();
            for(Jsep.Node argNode : node.arguments) {
                arguments.add(this.eval(argNode, context));
            }

            return this.evalCall(callee, arguments, context);
        }

        private Object eval(Jsep.ConditionalExpressionNode node, Map<String, Object> context) {
            Object test = this.eval(node.test, context);
            if(test != null && test instanceof Boolean) {
                if((Boolean)test) {
                    return this.eval(node.consequent, context);
                }
                else {
                    return this.eval(node.alternate, context);
                }
            }
            else {
                throw new TemplateException('Failed to execute conditional expression as test is not boolean');
            }
        }

        private Object eval(Jsep.UnaryExpressionNode node, Map<String, Object> context) {
            Object val = this.eval(node.argument, context);
            String op = node.operator;
            if(op == '-') {
                if(val instanceof Decimal) {
                    return -((Decimal)val);
                }
                else {
                    throw new TemplateException('Failed to execute "-" on non-number');
                }
            }
            else if(op == '!') {
                if(val instanceof Boolean) {
                    return !((Boolean)val);
                }
                else {
                    throw new TemplateException('Failed to execute "!" on non-boolean');
                }
            }
            else {
                throw new TemplateException('Unsupported operator for "' + op + '"');
            }
        }

        private Object eval(Jsep.BinaryExpressionNode node, Map<String, Object> context) {
            Object left = this.eval(node.left, context);
            Object right = this.eval(node.right, context);
            String operator = node.operator;
            if(operator == '==' || operator == '=') {
                return left == right;
            }
            else if(operator == '!=' || operator == '<>') {
                return left != right;
            }
            else if(operator == '<') {
                if(left instanceof Decimal && right instanceof Decimal) {
                    return ((Decimal)left) < ((Decimal)right);
                }
                else if(left instanceof String && right instanceof String) {
                    return ((String)left) < ((String)right);
                }
                else if(left instanceof Date && right instanceof Date) {
                    return ((Date)left) < ((Date)right);
                }
                else if(left instanceof Time && right instanceof Time) {
                    return ((Time)left) < ((Time)right);
                }
                else if(left instanceof Datetime && right instanceof Datetime) {
                    return ((Datetime)left) < ((Datetime)right);
                }
                else {
                    throw new TemplateException('Failed to execute "<" on objects');
                }
            }
            else if(operator == '>') {
                if(left instanceof Decimal && right instanceof Decimal) {
                    return ((Decimal)left) > ((Decimal)right);
                }
                else if(left instanceof String && right instanceof String) {
                    return ((String)left) > ((String)right);
                }
                else if(left instanceof Date && right instanceof Date) {
                    return ((Date)left) > ((Date)right);
                }
                else if(left instanceof Time && right instanceof Time) {
                    return ((Time)left) > ((Time)right);
                }
                else if(left instanceof Datetime && right instanceof Datetime) {
                    return ((Datetime)left) > ((Datetime)right);
                }
                else {
                    throw new TemplateException('Failed to execute ">" on objects');
                }
            }
            else if(operator == '<=') {
                if(left instanceof Decimal && right instanceof Decimal) {
                    return ((Decimal)left) <= ((Decimal)right);
                }
                else if(left instanceof String && right instanceof String) {
                    return ((String)left) <= ((String)right);
                }
                else if(left instanceof Date && right instanceof Date) {
                    return ((Date)left) <= ((Date)right);
                }
                else if(left instanceof Time && right instanceof Time) {
                    return ((Time)left) <= ((Time)right);
                }
                else if(left instanceof Datetime && right instanceof Datetime) {
                    return ((Datetime)left) <= ((Datetime)right);
                }
                else {
                    throw new TemplateException('Failed to execute "<=" on objects');
                }
            }
            else if(operator == '>=') {
                if(left instanceof Decimal && right instanceof Decimal) {
                    return ((Decimal)left) >= ((Decimal)right);
                }
                else if(left instanceof String && right instanceof String) {
                    return ((String)left) >= ((String)right);
                }
                else if(left instanceof Date && right instanceof Date) {
                    return ((Date)left) >= ((Date)right);
                }
                else if(left instanceof Time && right instanceof Time) {
                    return ((Time)left) >= ((Time)right);
                }
                else if(left instanceof Datetime && right instanceof Datetime) {
                    return ((Datetime)left) >= ((Datetime)right);
                }
                else {
                    throw new TemplateException('Failed to execute ">=" on objects');
                }
            }
            else if(operator == '+') {
                if(left instanceof Decimal && right instanceof Decimal) {
                    return ((Decimal)left) + ((Decimal)right);
                }
                else if(left instanceof Date && right instanceof Integer) {
                    return ((Date)left).addDays((Integer)right);
                }
                else if(left instanceof Datetime && right instanceof Integer) {
                    return ((Datetime)left).addDays((Integer)right);
                }
                else {
                    return String.valueOf(left) + String.valueOf(right);
                }
            }
            else if(operator == '-') {
                if(left instanceof Decimal && right instanceof Decimal) {
                    return ((Decimal)left) - ((Decimal)right);
                }
                else if(left instanceof Date && right instanceof Integer) {
                    return ((Date)left).addDays(-(Integer)right);
                }
                else if(left instanceof Datetime && right instanceof Integer) {
                    return ((Datetime)left).addDays(-(Integer)right);
                }
                else {
                    throw new TemplateException('Failed to execute "-" on objects');
                }
            }
            else if(operator == '*') {
                if(left instanceof Decimal && right instanceof Decimal) {
                    return ((Decimal)left) * ((Decimal)right);
                }
                else {
                    throw new TemplateException('Failed to execute "*" on objects');
                }
            }
            else if(operator == '/') {
                if(left instanceof Decimal && right instanceof Decimal) {
                    return ((Decimal)left) / ((Decimal)right);
                }
                else {
                    throw new TemplateException('Failed to execute "/" on objects');
                }
            }
            else if(operator == '^') {
                if(left instanceof Double && right instanceof Double) {
                    return Math.pow(((Double)left).longValue(), ((Double)right).longValue());
                }
                else {
                    throw new TemplateException('Failed to execute "^" on objects');
                }
            }
            else if(operator == '&') {
                return stringOf(left) + stringOf(right);
            }
            else {
                throw new TemplateException('Unsupported operator for "' + operator + '"');
            }
        }

        private Object eval(Jsep.LogicalExpressionNode node, Map<String, Object> context) {
            Object left = this.eval(node.left, context);
            Object right = this.eval(node.right, context);
            String operator = node.operator;
            if(operator == '&&') {
                if(left instanceof Boolean && right instanceof Boolean) {
                    return ((Boolean)left) && ((Boolean)right);
                }
                else {
                    throw new TemplateException('Failed to execute "&&" on non-boolean');
                }
            }
            else if(operator == '||') {
                if(left instanceof Boolean && right instanceof Boolean) {
                    return ((Boolean)left) || ((Boolean)right);
                }
                else {
                    throw new TemplateException('Failed to execute "||" on non-boolean');
                }
            }
            else {
                throw new TemplateException('Unsupported operator for "' + operator + '"');
            }
        }

        private Object eval(Jsep.AssignmentExpressionNode node, Map<String, Object> context) {
            Object left = this.eval(node.left, context);
            Object right = this.eval(node.right, context);
            String operator = node.operator;
            if(operator == '=') {
                return left == right;
            }
            else {
                throw new TemplateException('Unsupported operator for "' + operator + '"');
            }
        }
    }
}
