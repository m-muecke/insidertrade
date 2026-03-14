test_that("edgar_submissions() validates inputs", {
  expect_error(edgar_submissions(-1))
  expect_error(edgar_submissions("abc"))
  expect_error(edgar_submissions(NULL))
})

test_that("edgar_form4() validates inputs", {
  expect_error(edgar_form4(-1, "0001-24-000001", "doc.xml"))
  expect_error(edgar_form4("abc", "0001-24-000001", "doc.xml"))
  expect_error(edgar_form4(123, 123, "doc.xml"))
  expect_error(edgar_form4(123, "0001-24-000001", 123))
})

test_that("parse_form4_xml() parses non-derivative transactions", {
  xml <- xml2::read_xml(
    '
    <ownershipDocument>
      <issuer>
        <issuerCik>0000320193</issuerCik>
        <issuerName>Apple Inc</issuerName>
        <issuerTradingSymbol>AAPL</issuerTradingSymbol>
      </issuer>
      <reportingOwner>
        <reportingOwnerId>
          <rptOwnerCik>0001234567</rptOwnerCik>
          <rptOwnerName>DOE JOHN</rptOwnerName>
        </reportingOwnerId>
        <reportingOwnerRelationship>
          <isDirector>0</isDirector>
          <isOfficer>1</isOfficer>
          <isTenPercentOwner>0</isTenPercentOwner>
          <isOther>0</isOther>
          <officerTitle>SVP</officerTitle>
        </reportingOwnerRelationship>
      </reportingOwner>
      <nonDerivativeTable>
        <nonDerivativeTransaction>
          <securityTitle><value>Common Stock</value></securityTitle>
          <transactionDate><value>2024-01-15</value></transactionDate>
          <transactionCoding>
            <transactionFormType>4</transactionFormType>
            <transactionCode>S</transactionCode>
            <equitySwapInvolved>0</equitySwapInvolved>
          </transactionCoding>
          <transactionAmounts>
            <transactionShares><value>1000</value></transactionShares>
            <transactionPricePerShare><value>185.50</value></transactionPricePerShare>
            <transactionAcquiredDisposedCode><value>D</value></transactionAcquiredDisposedCode>
          </transactionAmounts>
          <postTransactionAmounts>
            <sharesOwnedFollowingTransaction><value>5000</value></sharesOwnedFollowingTransaction>
          </postTransactionAmounts>
          <ownershipNature>
            <directOrIndirectOwnership><value>D</value></directOrIndirectOwnership>
          </ownershipNature>
        </nonDerivativeTransaction>
      </nonDerivativeTable>
    </ownershipDocument>
  '
  )

  res <- parse_form4_xml(xml)
  expect_s3_class(res, "data.table")
  expect_equal(nrow(res), 1L)
  expect_equal(res$issuer_cik, "0000320193")
  expect_equal(res$issuer_name, "Apple Inc")
  expect_equal(res$issuer_ticker, "AAPL")
  expect_equal(res$owner_cik, "0001234567")
  expect_equal(res$owner_name, "DOE JOHN")
  expect_false(res$is_director)
  expect_true(res$is_officer)
  expect_equal(res$officer_title, "SVP")
  expect_equal(res$security_title, "Common Stock")
  expect_equal(res$transaction_date, as.Date("2024-01-15"))
  expect_equal(res$transaction_code, "S")
  expect_equal(res$shares, 1000)
  expect_equal(res$price_per_share, 185.50)
  expect_equal(res$acquired_disposed, "D")
  expect_equal(res$shares_owned_following, 5000)
  expect_equal(res$direct_or_indirect, "D")
})

test_that("parse_form4_xml() returns empty data.table when no transactions", {
  xml <- xml2::read_xml(
    '
    <ownershipDocument>
      <issuer>
        <issuerCik>0000320193</issuerCik>
        <issuerName>Apple Inc</issuerName>
        <issuerTradingSymbol>AAPL</issuerTradingSymbol>
      </issuer>
      <reportingOwner>
        <reportingOwnerId>
          <rptOwnerCik>0001234567</rptOwnerCik>
          <rptOwnerName>DOE JOHN</rptOwnerName>
        </reportingOwnerId>
        <reportingOwnerRelationship>
          <isDirector>1</isDirector>
          <isOfficer>0</isOfficer>
          <isTenPercentOwner>0</isTenPercentOwner>
          <isOther>0</isOther>
        </reportingOwnerRelationship>
      </reportingOwner>
      <nonDerivativeTable />
    </ownershipDocument>
  '
  )

  res <- parse_form4_xml(xml)
  expect_s3_class(res, "data.table")
  expect_equal(nrow(res), 0L)
  expect_equal(ncol(res), 18L)
})
