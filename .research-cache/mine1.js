
const fs=require('fs');
const D=process.argv[2];
const C=JSON.parse(fs.readFileSync(D+'/pp_comments.json','utf8'));
const S=JSON.parse(fs.readFileSync(D+'/pp_submissions.json','utf8'));
const all=[...S.map(x=>({...x,kind:'P'})),...C.map(x=>({...x,kind:'C'}))];
const CATS={
 AO:/assembl|\bAO\b|shapes|put together|line them|connect/i,
 WK:/word knowledge|vocab|synonym|antonym|words (i|I)('ve| have)? (never|didn'?t)|definitions/i,
 MK:/math knowledge|algebra|quadratic|exponent|fraction|geometry|solve for/i,
 AR:/arithmetic reasoning|word problem|story problem|percent|ratio/i,
 MC:/mechanical comprehension|pulley|lever|gear|torque|psi/i,
 EI:/electronic|circuit|ohm|resistor|voltage|amp/i,
 AS:/auto (info|shop|motive)|shop information|auto shop|carburetor|wrench|tools/i,
 GS:/general science|science (section|part)|biology|chemistry|astronomy/i,
 PC:/paragraph comprehension|reading comp|passage|read(ing)? section/i,
 ADAPT:/adaptiv|got harder|getting harder|kept getting|harder (questions|as)|easier questions/i,
 PACE:/ran out of time|out of time|timer|time limit|rushed|ran short|time crunch/i,
 PRACT:/practice test|dummies|study guide|quizlet|app (that|for)|khan|youtube/i,
 SCORE:/AFQT|\bGT\b|GT score|scored (a )?\d|\b(3[0-9]|[4-9][0-9]|100)\b on/i,
 RETEST:/retest|retake|took it (twice|two|again)|second time/i,
 PICAT:/picat|pi-cat|verification test/i
};
const res={};
for(const k of Object.keys(CATS)){ res[k]=all.filter(x=>CATS[k].test(x.title+' '+x.text)); }
for(const k of Object.keys(res)) console.log(k+': '+res[k].length);
fs.writeFileSync(D+'/cats.json', JSON.stringify(res));
