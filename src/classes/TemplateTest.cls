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
@isTest
private class TemplateTest {
    private static Template t = new Template();

    @isTest
    private static void evaluateTest() {
        String output = t.evaluate('abcdef', new Map<String, Object>());
        System.assertEquals('abcdef', output);

        output = t.evaluate('{! name }', new Map<String, Object>{ 'NAME' => 'test'});
        System.assertEquals('test', output);

        output = t.evaluate('$ {! name }, {!desc}', new Map<String, Object>{ 'name' => 'test', 'desc' => 'xxx'});
        System.assertEquals('$ test, xxx', output);

        output = t.evaluate('{! name }', new Map<String, Object>{});
        System.assertEquals('', output);
    }

    @isTest
    private static void binaryOperatorTest() {
        String output = t.evaluate('{! 1 == 1}', new Map<String, Object>());
        System.assertEquals('true', output);

        output = t.evaluate('{! 1 = 1}', new Map<String, Object>());
        System.assertEquals('true', output);

        output = t.evaluate('{! 1 != 1}', new Map<String, Object>());
        System.assertEquals('false', output);

        output = t.evaluate('{! 1 <> 1}', new Map<String, Object>());
        System.assertEquals('false', output);

        output = t.evaluate('{! 1 < 2}', new Map<String, Object>());
        System.assertEquals('true', output);

        output = t.evaluate('{! 1 > 2}', new Map<String, Object>());
        System.assertEquals('false', output);

        output = t.evaluate('{! 1 <= 2}', new Map<String, Object>());
        System.assertEquals('true', output);

        output = t.evaluate('{! 1 >= 2}', new Map<String, Object>());
        System.assertEquals('false', output);

        output = t.evaluate('{! 1 + 2}', new Map<String, Object>());
        System.assertEquals('3', output);

        output = t.evaluate('{! 1 - 2}', new Map<String, Object>());
        System.assertEquals('-1', output);

        output = t.evaluate('{! 1 * 2}', new Map<String, Object>());
        System.assertEquals('2', output);

        output = t.evaluate('{! 1 / 2}', new Map<String, Object>());
        System.assertEquals('0.5', output);

        output = t.evaluate('{! 1 ^ 2}', new Map<String, Object>());
        System.assertEquals('1.0', output);

        output = t.evaluate('{! "a" & "b"}', new Map<String, Object>());
        System.assertEquals('ab', output);
    }

    @isTest
    private static void logicalOperatorTest() {
        String output = t.evaluate('{! true && false}', new Map<String, Object>());
        System.assertEquals('false', output);

        output = t.evaluate('{! true || false}', new Map<String, Object>());
        System.assertEquals('true', output);
    }

    @isTest
    private static void unaryOperatorTest() {
        String output = t.evaluate('{! -1}', new Map<String, Object>());
        System.assertEquals('-1', output);

        output = t.evaluate('{! !true}', new Map<String, Object>());
        System.assertEquals('false', output);
    }

    @isTest
    private static void conditionalOperatorTest() {
        String output = t.evaluate('{! val ? "a" : "b" }', new Map<String, Object>{ 'val' => true});
        System.assertEquals('a', output);
    }

    @isTest
    private static void addMonthsTest() {
        String output = t.evaluate('{! addMonths(d, 1)}', new Map<String, Object>{ 'd' => Date.newInstance(2018, 1, 1) });
        System.assertEquals('2018-02-01 00:00:00', output);
    }

    @isTest
    private static void dateTest() {
        String output = t.evaluate('{! date(2018, 1, 1)}', new Map<String, Object>{});
        System.assertEquals('2018-01-01 00:00:00', output);
    }

    @isTest
    private static void dateValueTest() {
        String output = t.evaluate('{! dateValue(d)}', new Map<String, Object>{ 'd' => Datetime.newInstance(2018, 1, 1, 0, 0, 0) });
        System.assertEquals('2018-01-01 00:00:00', output);
    }

    @isTest
    private static void datetimeValueTest() {
        String output = t.evaluate('{! datetimeValue("2018-01-01 00:00:00")}', new Map<String, Object>{});
        System.assertEquals('2018-01-01 00:00:00', output);
    }

    @isTest
    private static void dayTest() {
        String output = t.evaluate('{! day(d)}', new Map<String, Object>{ 'd' => Date.newInstance(2018, 1, 1) });
        System.assertEquals('1', output);
    }

    @isTest
    private static void monthTest() {
        String output = t.evaluate('{! month(d)}', new Map<String, Object>{ 'd' => Date.newInstance(2018, 1, 1) });
        System.assertEquals('1', output);
    }

    @isTest
    private static void yearTest() {
        String output = t.evaluate('{! year(d)}', new Map<String, Object>{ 'd' => Date.newInstance(2018, 1, 1) });
        System.assertEquals('2018', output);
    }

    @isTest
    private static void weekdayTest() {
        String output = t.evaluate('{! weekday(d)}', new Map<String, Object>{ 'd' => Date.newInstance(2018, 5, 1) });
        System.assertEquals('3', output);
    }

    @isTest
    private static void blankValueTest() {
        String output = t.evaluate('{! blankvalue("", "value")}', new Map<String, Object>{});
        System.assertEquals('value', output);
    }

    @isTest
    private static void caseTest() {
        String output = t.evaluate('{! case(val, "a", 1, "b", 2)}', new Map<String, Object>{ 'val' => 'a' });
        System.assertEquals('1', output);
    }

    @isTest
    private static void ifTest() {
        String output = t.evaluate('{! if(val, "a", "b")}', new Map<String, Object>{ 'val' => true});
        System.assertEquals('a', output);
    }

    @isTest
    private static void isBlankTest() {
        String output = t.evaluate('{! isBlank(val)}', new Map<String, Object>{ 'val' => ''});
        System.assertEquals('true', output);
    }

    @isTest
    private static void nullValueTest() {
        String output = t.evaluate('{! nullValue(val, "a")}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('a', output);
    }

    @isTest
    private static void absTest() {
        String output = t.evaluate('{! abs(-1)}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('1.0', output);
    }

    @isTest
    private static void ceilingTest() {
        String output = t.evaluate('{! ceiling(-1.6)}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('-2.0', output);
    }

    @isTest
    private static void expTest() {
        String output = t.evaluate('{! exp(2)}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('7.38905609893065', output);
    }

    @isTest
    private static void floorTest() {
        String output = t.evaluate('{! floor(-1.3)}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('-1.0', output);
    }

    @isTest
    private static void lnTest() {
        String output = t.evaluate('{! ln(3)}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('1.0986122886681098', output);
    }

    @isTest
    private static void logTest() {
        String output = t.evaluate('{! log(30)}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('1.4771212547196624', output);
    }

    @isTest
    private static void maxTest() {
        String output = t.evaluate('{! max(1, 2, 3)}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('3', output);
    }

    @isTest
    private static void minTest() {
        String output = t.evaluate('{! min(1, 2, 3)}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('1', output);
    }

    @isTest
    private static void mceilingTest() {
        String output = t.evaluate('{! mceiling(1.6)}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('2.0', output);
    }

    @isTest
    private static void mfloorTest() {
        String output = t.evaluate('{! mfloor(1.3)}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('1.0', output);
    }

    @isTest
    private static void roundTest() {
        String output = t.evaluate('{! round(1.23, 2)}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('1.2', output);
    }

    @isTest
    private static void sqrtTest() {
        String output = t.evaluate('{! sqrt(4)}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('2.0', output);
    }

    @isTest
    private static void findTest() {
        String output = t.evaluate('{! find("abc", "a")}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('0', output);
    }

    @isTest
    private static void getSessionIdTest() {
        String output = t.evaluate('{! getSessionId()}', new Map<String, Object>{ 'val' => null});
        System.assert(output != '');
    }

    @isTest
    private static void htmlEncodeTest() {
        String output = t.evaluate('{! htmlEncode("<")}', new Map<String, Object>{ 'val' => null});
        System.assertEquals('&lt;', output);
    }

    @isTest
    private static void jsEncodeTest() {
        String output = t.evaluate('{! jsEncode(val)}', new Map<String, Object>{ 'val' => '\\'});
        System.assertEquals('\\\\', output);
    }

    @isTest
    private static void leftTest() {
        String output = t.evaluate('{! left("abc", 2)}', new Map<String, Object>{ 'val' => null });
        System.assertEquals('ab', output);
    }

    @isTest
    private static void lowerTest() {
        String output = t.evaluate('{! lower("ABC")}', new Map<String, Object>{ 'val' => null });
        System.assertEquals('abc', output);
    }

    @isTest
    private static void upperTest() {
        String output = t.evaluate('{! upper("abc")}', new Map<String, Object>{ 'val' => null });
        System.assertEquals('ABC', output);
    }

    @isTest
    private static void leftPadTest() {
        String output = t.evaluate('{! lpad("abc", 5, "*")}', new Map<String, Object>{ 'val' => null });
        System.assertEquals('**abc', output);
    }

    @isTest
    private static void rightPadTest() {
        String output = t.evaluate('{! rpad("abc", 5, "*")}', new Map<String, Object>{ 'val' => null });
        System.assertEquals('abc**', output);
    }

    @isTest
    private static void midTest() {
        String output = t.evaluate('{! mid("abc", 1, 1)}', new Map<String, Object>{ 'val' => null });
        System.assertEquals('b', output);
    }

    @isTest
    private static void urlEncodeTest() {
        String output = t.evaluate('{! urlEncode("!")}', new Map<String, Object>{ 'val' => null });
        System.assertEquals('%21', output);
    }

    @isTest
    private static void memberTest() {
        String output = t.evaluate('{! data.name }', new Map<String, Object>{ 'data' => new Map<String, Object>{ 'name' => 'test' } });
        System.assertEquals('test', output);
    }
}
