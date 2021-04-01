const fs = require('fs');
const readline = require('readline');
const { google } = require('googleapis');


// If modifying these scopes, delete token.json.
const SCOPES = ['https://www.googleapis.com/auth/drive'];
// The file token.json stores the user's access and refresh tokens, and is
// created automatically when the authorization flow completes for the first
// time.
const TOKEN_PATH = 'token.json';

// Load client secrets from a local file.

/**
 * Create an OAuth2 client with the given credentials, and then execute the
 * given callback function.
 * @param {Object} credentials The authorization client credentials.
 * @param {function} callback The callback to call with the authorized client.
 */

//let content = fs.readFileSync('credentials.json');
function authorize(credentials) {
        const { client_secret, client_id, redirect_uris } = credentials.installed;
        const oAuth2Client = new google.auth.OAuth2(
                client_id, client_secret, redirect_uris[0]);

        let token = fs.readFileSync(TOKEN_PATH);

        oAuth2Client.setCredentials(JSON.parse(token));
        return oAuth2Client


        // Check if we have previously stored a token.
        // , (err, token) => {
        //if (err) return getAccessToken(oAuth2Client, callback);

        // callback(oAuth2Client);
        // });
}

/**
 * Get and store new token after prompting for user authorization, and then
 * execute the given callback with the authorized OAuth2 client.
 * @param {google.auth.OAuth2} oAuth2Client The OAuth2 client to get token for.
 * @param {getEventsCallback} callback The callback for the authorized client.
 */
function getAccessToken(oAuth2Client, callback) {
        const authUrl = oAuth2Client.generateAuthUrl({
                access_type: 'offline',
                scope: SCOPES,
        });

        console.log('Authorize this app by visiting this url:', authUrl);
        const rl = readline.createInterface({
                input: process.stdin,
                output: process.stdout,
        });
        rl.question('Enter the code from that page here: ', (code) => {
                rl.close();
                oAuth2Client.getToken(code, (err, token) => {
                        if (err) return console.error('Error retrieving access token', err);
                        oAuth2Client.setCredentials(token);
                        // Store the token to disk for later program executions
                        fs.writeFile(TOKEN_PATH, JSON.stringify(token), (err) => {
                                if (err) return console.error(err);
                                console.log('Token stored to', TOKEN_PATH);
                        });
                        callback(oAuth2Client);
                });
        });
}

/**
 * Lists the names and IDs of up to 10 files.
 * @param {google.auth.OAuth2} auth An authorized OAuth2 client.
 */

function loadFunc(name) {
        let content = fs.readFileSync('credentials.json');

        return authorize(JSON.parse(content));

}


exports.loadFunc = loadFunc;