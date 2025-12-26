using System.Globalization;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;

namespace BarInventory.Helpers;

public static class StringHelpers
{

    public static string TextToHtml(string? text)
    {
        if (string.IsNullOrEmpty(SanitizeString(text))) 
            return string.Empty;

        string newhtml = string.Empty;

        // Emails
        var emailParser = new Regex(@"\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b", RegexOptions.Compiled | RegexOptions.IgnoreCase);
        string emailModifiedText = text;
        foreach (Match m in emailParser.Matches(text))
        {
            newhtml = $"<a href=\"mailto:{m.Value}\">{m.Value}</a>";
            emailModifiedText = emailModifiedText.Replace(m.Value, newhtml);
        }
        text = emailModifiedText;

        // Links
        if (text!.Contains("://"))
        {
            string linkmodifiedText = text; // Create a copy of the original text
            var linkParser = new Regex(@"\b(?:https?://|www\.)\S+\b", RegexOptions.Compiled | RegexOptions.IgnoreCase);
            foreach (Match m in linkParser.Matches(text))
            {
                newhtml = $"<a href=\"{m.Value}\" target='_blank'>{m.Value.Replace("https://", "")}</a>";
                linkmodifiedText = linkmodifiedText.Replace(m.Value, newhtml);
            }
            text = linkmodifiedText;

        }

        // Phone Numbers
        string modifiedText = text; // Create a copy of the original text
        var phoneParser = new Regex(@"\b(?:\d{3}[-.\s]??\d{3}[-.\s]??\d{4}\b)", RegexOptions.Compiled | RegexOptions.IgnoreCase);
        foreach (Match m in phoneParser.Matches(text))
        {
            //Console.WriteLine("Match found: " + m.Value);
            newhtml = $"<a href=\"tel:{m.Value}\">{m.Value}</a>";
            modifiedText = modifiedText.Replace(m.Value, newhtml);
        }
        text = modifiedText;

        //text = HttpUtility.HtmlEncode(text);
        // CRLF
        text = text.Replace("\r\n", "\r");
        text = text.Replace("\n", "\r");
        text = text.Replace("\r", "<br>\r\n");
        text = text.Replace("  ", " &nbsp;");
        text = text.Replace("<br>\r\n<br>\r\n", "<br>\r\n");

        return text;
    }

    public static string SanitizeString(string? Notes, string? replacewhat = null, string? replacewith = null)
    {
        // if this note is empty, null, or just filled with spaces and CR/LF, return empty
        if (string.IsNullOrEmpty(Notes)) return string.Empty;
        Notes = Notes.Replace("\r\n", ""); Notes = Notes.Replace("\r", ""); Notes = Notes.Replace("\n", ""); Notes = Notes.Trim();
        if (string.IsNullOrEmpty(Notes)) return string.Empty;

        if (replacewhat is not null && replacewith is not null)
        {
            Notes = Notes.Replace(replacewhat, replacewith);
        }

        return Notes;
    }

    public static string ObjectToJSON(object o, bool writeIndented = true)
    {
        var options = new JsonSerializerOptions
        {
            WriteIndented = writeIndented
        };
        return JsonSerializer.Serialize(o, options);
    }

    public static string StripAlphas(string StrVal)
    {
        string value = Regex.Replace(StrVal, "[A-Za-z ]", "");
        return (value);
    }


    public static string FormatNameFirstLast(string fullName)
    {
        if (fullName.Contains(","))
        {
            var parts = fullName.Split(new[] { ',' }, 2);
            if (parts.Length == 2)
            {
                var firstName = parts[1].Trim();
                var lastName = parts[0].Trim();
                return $"{firstName} {lastName}";
            }
        }
        // Return original string if no comma is found or splitting fails
        return fullName;
    }


    public static string Truncate(string value, int length)
    {
        if (!String.IsNullOrEmpty(value) && length > 0)
        {
            if (value.Length > length) return value.Substring(0, length);
        }
        return value;
    }

    public static string ReverseStringByCRLF(string strNote)
    {
        string retVal = "";
        string[] arr = strNote.Replace("\r\n", "\n").Split("\n".ToCharArray());
        if (arr.Count() - 1 > 0)
        {
            for (int i = arr.Count() - 1; i >= 0; i--)
            {
                retVal = string.Concat(retVal, arr[i], "\r\n");
            }
        }
        // strip leading \r\n's
        while (retVal.StartsWith("\r\n"))
        {
            retVal = retVal.Substring(2);
        }
        return retVal;
    }

    public static string AsInternationalPhoneFormat(this string input, int countryCode = 1)
    {
        if (string.IsNullOrEmpty(input))
        {
            throw new ArgumentException($"'{nameof(input)}' cannot be null or empty.", nameof(input));
        }

        bool appendCountryPrefix = true;
        string result = string.Empty;

        for (int idx = 0; idx != input.Length; idx++)
        {
            result += input[idx];

            if (idx == 0 && input[idx] == '+')
            {
                appendCountryPrefix = false;
            }
        }
        if (appendCountryPrefix)
        {
            result = $"+{countryCode}{result}";
        }

        return result;
    }

    public static string AsMaskedPhone(this string input)
    {
        if (string.IsNullOrEmpty(input))
        {
            throw new ArgumentException($"'{nameof(input)}' cannot be null or empty.", nameof(input));
        }

        string fixedPhone = input.AsInternationalPhoneFormat()!;
        return $"{fixedPhone.Substring(2, 3)}-***-{fixedPhone.Substring(8)}";
    }

    public static string AsMaskedEmail(this string input)
    {
        if (string.IsNullOrEmpty(input))
        {
            throw new ArgumentException($"'{nameof(input)}' cannot be null or empty.", nameof(input));
        }

        int symbolPosition = input.IndexOf("@");
        return $"{input.Substring(0, 1)}{new string('*', symbolPosition - 2)}{input.Substring(symbolPosition - 1)}";

    }

    // Because i miss VB...
    public static string Right(this string str, int length)
    {
        if (str == null) return null;
        if (string.IsNullOrEmpty(str)) return "";
        if (str.Length <= length) return str;
        return str.Substring(str.Length - length, length);
    }
    public static string Left(this string str, int length)
    {
        if (str == null) return null;
        if (string.IsNullOrEmpty(str)) return string.Empty;
        if (str.Length <= length) return str;
        return str[..length];
    }

    public static string GetInitials(string input) =>
    string.IsNullOrWhiteSpace(input)
    ? string.Empty
    : string.Concat(input.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)
                         .Select(word => word[0]));

    public static string TitleCase(this string StrVal)
    {
        StrVal ??= "";
        string retval = StrVal;
        if (!string.IsNullOrEmpty(StrVal))
        {
            // titlecase it to be nice for our data
            TextInfo addrTI = new CultureInfo("en-US", false).TextInfo;
            retval = addrTI.ToTitleCase(StrVal.ToLower());
        }
        return (retval);
    }

    
}

