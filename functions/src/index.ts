import * as functions from "firebase-functions";
import * as rp from "request-promise";
// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const omdbapiSearch = functions.https.onRequest((request, response) => {
  // functions.logger.info("Hello logs!", {structuredData: true});
  let results;
  const search = request.query.search;
  rp("https://www.omdbapi.com/?s=" + search + "&apikey=thewdb")
      .then((body) => {
        results = JSON.parse(body);
        if (results["Response"] == "True") {
          response.json(results);
        }
      }).catch(function(err) {
        const respErr = JSON.parse(err.error);
        const errorResult = {
          origUrl: respErr.origUrl,
          error: respErr,
        };
        results.push(errorResult);
      }).catch(function(err) {
        console.error(err);
      });
  // response.send(results);
});

export const omdbapiMovie = functions.https.onRequest((request, response) => {
  // functions.logger.info("Hello logs!", {structuredData: true});
  let results;
  rp("https://www.omdbapi.com/?i=" + request.query.movie + "&apikey=thewdb")
      .then((body) => {
        results = JSON.parse(body);
        if (results["Response"] == "True") {
          response.json(results);
        }
      }).catch(function(err) {
        const respErr = JSON.parse(err.error);
        const errorResult = {
          origUrl: respErr.origUrl,
          error: respErr,
        };
        results.push(errorResult);
      }).catch(function(err) {
        console.error(err);
      });
});

export const omdbapi = functions.https.onCall((data, context) => {
  // let results;
  // let index = 0;
  rp("https://www.omdbapi.com/?s=black&apikey=dbb17756")
      .then((body) => {
        console.log(body.json);
        return {
          response: body.json,
        };
      // }
      });
});

