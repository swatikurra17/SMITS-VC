trigger helloworld on Lead (before update) {
for (Lead l : trigger.new)
{
l.FirstName='Hello';
l.LastName='World';
l.Company='test';

}

}